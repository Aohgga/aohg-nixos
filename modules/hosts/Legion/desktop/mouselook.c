// SPDX-License-Identifier: MIT
// mouselook — 按住方向键时以固定速率向 ydotoold 注入相对鼠标事件。
//
// 为什么不用 `ydotool mousemove` 循环：那样每次事件都要 fork/exec 一个进程，
// 实际只能做到 60~90Hz、每步 3px，游戏里会看到一格一格的跳变，而且 CPU 都花在
// 进程启动上。这里改成常驻守护进程，和 ydotoold 保持一条 unix socket，
// 按 1ms 的节奏累积小数位移、攒够 1px 就发一个事件（约 350 事件/秒），
// 空闲时 poll 阻塞，不占 CPU。
//
// 用法：
//   mouselook start <name> <ux> <uy> [speed]   按住（ux/uy 为方向单位向量）
//   mouselook stop  <name>                     松开
//   mouselook stop-all                         全部停止
//
// 第一次 start 会自动拉起 daemon。每个方向最长 30 秒，防止松开事件丢失。

#define _GNU_SOURCE

#include <errno.h>
#include <limits.h>
#include <poll.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/un.h>
#include <time.h>
#include <unistd.h>

#include <linux/input.h>

#define MAX_DIRS 16
#define NAME_LEN 32
#define DEF_SPEED 350.0
#define HOLD_SECONDS 30.0

struct dir {
    char name[NAME_LEN];
    int ux, uy;
    double speed;
    double deadline;
};

static struct dir dirs[MAX_DIRS];
static int ndirs;
static int yfd = -1;
static int cfd = -1;
static char ctrl_path[104];

static double now_sec(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (double)ts.tv_sec + (double)ts.tv_nsec / 1e9;
}

static void ctrl_path_init(void)
{
    const char *xrd = getenv("XDG_RUNTIME_DIR");
    snprintf(ctrl_path, sizeof ctrl_path, "%s/mouselook.sock",
             (xrd && *xrd) ? xrd : "/tmp");
}

static void ydotool_path(struct sockaddr_un *sa)
{
    const char *ys = getenv("YDOTOOL_SOCKET");
    if (ys && *ys) {
        snprintf(sa->sun_path, sizeof sa->sun_path, "%s", ys);
    } else {
        const char *xrd = getenv("XDG_RUNTIME_DIR");
        if (xrd && *xrd) {
            snprintf(sa->sun_path, sizeof sa->sun_path, "%s/.ydotool_socket", xrd);
        } else {
            snprintf(sa->sun_path, sizeof sa->sun_path, "/tmp/.ydotool_socket");
        }
    }
}

static int send_cmd(const char *msg)
{
    struct sockaddr_un sa = { .sun_family = AF_UNIX };
    snprintf(sa.sun_path, sizeof sa.sun_path, "%s", ctrl_path);

    int fd = socket(AF_UNIX, SOCK_DGRAM, 0);
    if (fd < 0) {
        return -1;
    }
    const ssize_t n = sendto(fd, msg, strlen(msg), 0, (struct sockaddr *)&sa, sizeof sa);
    close(fd);
    return n == (ssize_t)strlen(msg) ? 0 : -1;
}

static void ensure_daemon(void)
{
    if (send_cmd("ping") == 0) {
        return;
    }

    const pid_t pid = fork();
    if (pid == 0) {
        setsid();
        char exe[PATH_MAX];
        const ssize_t n = readlink("/proc/self/exe", exe, sizeof exe - 1);
        if (n > 0) {
            exe[n] = '\0';
            execl(exe, "mouselook", "daemon", (char *)NULL);
        }
        _exit(127);
    }

    for (int i = 0; i < 250; i++) {
        if (send_cmd("ping") == 0) {
            return;
        }
        struct timespec ts = { .tv_nsec = 2000000 };
        nanosleep(&ts, NULL);
    }
    fprintf(stderr, "mouselook: daemon did not start\n");
    exit(1);
}

static void write_ev(const struct input_event *ev)
{
    /* ydotoold 的 socket 是非阻塞的：它暂时读不过来时丢事件，不能把 daemon 卡住，
       否则按键松开也处理不了 */
    if (write(yfd, ev, sizeof *ev) < 0 && errno != EAGAIN && errno != EWOULDBLOCK) {
        _exit(1);
    }
}

static void emit(int dx, int dy)
{
    struct input_event ev;

    if (dx) {
        memset(&ev, 0, sizeof ev);
        ev.type = EV_REL;
        ev.code = REL_X;
        ev.value = dx;
        write_ev(&ev);
    }
    if (dy) {
        memset(&ev, 0, sizeof ev);
        ev.type = EV_REL;
        ev.code = REL_Y;
        ev.value = dy;
        write_ev(&ev);
    }
    memset(&ev, 0, sizeof ev);
    ev.type = EV_SYN;
    ev.code = SYN_REPORT;
    write_ev(&ev);
}

static struct dir *find_dir(const char *name)
{
    for (int i = 0; i < ndirs; i++) {
        if (strcmp(dirs[i].name, name) == 0) {
            return &dirs[i];
        }
    }
    return NULL;
}

static void remove_dir(const char *name)
{
    struct dir *d = find_dir(name);
    if (d) {
        *d = dirs[--ndirs];
    }
}

static void handle_cmd(char *msg)
{
    char name[NAME_LEN];
    int ux, uy;
    double speed;

    if (strncmp(msg, "start ", 6) == 0) {
        const int n = sscanf(msg + 6, "%31s %d %d %lf", name, &ux, &uy, &speed);
        if (n < 3) {
            return;
        }
        if (n < 4 || speed <= 0) {
            speed = DEF_SPEED;
        }
        struct dir *d = find_dir(name);
        if (!d) {
            if (ndirs >= MAX_DIRS) {
                return;
            }
            d = &dirs[ndirs++];
            snprintf(d->name, sizeof d->name, "%s", name);
        }
        d->ux = ux;
        d->uy = uy;
        d->speed = speed;
        d->deadline = now_sec() + HOLD_SECONDS;
    } else if (strncmp(msg, "stop ", 5) == 0) {
        if (sscanf(msg + 5, "%31s", name) == 1) {
            remove_dir(name);
        }
    } else if (strcmp(msg, "stop-all") == 0) {
        ndirs = 0;
    } else if (strcmp(msg, "quit") == 0) {
        unlink(ctrl_path);
        _exit(0);
    }
}

static int daemon_main(void)
{
    ctrl_path_init();

    if (send_cmd("ping") == 0) {
        return 0; /* 已有 daemon 在跑 */
    }
    unlink(ctrl_path);

    cfd = socket(AF_UNIX, SOCK_DGRAM, 0);
    if (cfd < 0) {
        return 1;
    }
    struct sockaddr_un csa = { .sun_family = AF_UNIX };
    snprintf(csa.sun_path, sizeof csa.sun_path, "%s", ctrl_path);
    if (bind(cfd, (struct sockaddr *)&csa, sizeof csa) < 0) {
        perror("mouselook: bind");
        return 1;
    }
    chmod(ctrl_path, 0600);

    yfd = socket(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0);
    if (yfd < 0) {
        return 1;
    }
    struct sockaddr_un ysa = { .sun_family = AF_UNIX };
    ydotool_path(&ysa);
    if (connect(yfd, (struct sockaddr *)&ysa, sizeof ysa) < 0) {
        fprintf(stderr, "mouselook: cannot connect %s: %s\n", ysa.sun_path, strerror(errno));
        return 1;
    }

    signal(SIGPIPE, SIG_IGN);

    double accx = 0, accy = 0;
    double last = now_sec();

    for (;;) {
        const double t = now_sec();

        for (int i = 0; i < ndirs;) {
            if (dirs[i].deadline < t) {
                dirs[i] = dirs[--ndirs];
            } else {
                i++;
            }
        }

        double vx = 0, vy = 0, speed = 0;
        for (int i = 0; i < ndirs; i++) {
            vx += dirs[i].ux;
            vy += dirs[i].uy;
            if (dirs[i].speed > speed) {
                speed = dirs[i].speed;
            }
        }
        if (vx != 0 && vy != 0) { /* 斜向保持速度一致 */
            vx *= 0.70710678;
            vy *= 0.70710678;
        }

        static int was_active = 0;
        const int active = (vx != 0 || vy != 0);
        if (active && !was_active) {
            /* 从空闲恢复：丢掉阻塞期间累积的时间，避免第一下跳一大步 */
            last = t;
            accx = 0;
            accy = 0;
        }
        was_active = active;

        double dt = t - last;
        last = t;
        if (dt > 0.02) {
            dt = 0.02;
        }

        if (active) {
            const double k = speed * dt;
            accx += vx * k;
            accy += vy * k;
            const int ix = (int)accx;
            const int iy = (int)accy;
            accx -= ix;
            accy -= iy;
            if (ix || iy) {
                emit(ix, iy);
            }
        } else {
            accx = 0;
            accy = 0;
        }

        struct pollfd pfd = { .fd = cfd, .events = POLLIN };
        const int timeout = active ? 1 : 600000; /* 空闲 10 分钟后自己退出 */
        const int pr = poll(&pfd, 1, timeout);
        if (!active && pr == 0) {
            unlink(ctrl_path);
            _exit(0);
        }
        if (pr > 0) {
            char msg[128];
            const ssize_t n = recv(cfd, msg, sizeof msg - 1, 0);
            if (n > 0) {
                msg[n] = '\0';
                handle_cmd(msg);
            }
        }
    }
}

static void usage(void)
{
    fprintf(stderr,
            "usage: mouselook start <name> <ux> <uy> [speed]\n"
            "       mouselook stop <name>\n"
            "       mouselook stop-all\n");
    exit(2);
}

int main(int argc, char **argv)
{
    char msg[128];

    ctrl_path_init();

    if (argc == 2 && strcmp(argv[1], "daemon") == 0) {
        return daemon_main();
    }

    if (argc == 2 && (strcmp(argv[1], "quit") == 0 || strcmp(argv[1], "stop-all") == 0)) {
        const char *cmd = strcmp(argv[1], "quit") == 0 ? "quit" : "stop-all";
        return send_cmd(cmd) == 0 ? 0 : 1;
    }

    if (argc == 3 && strcmp(argv[1], "stop") == 0) {
        snprintf(msg, sizeof msg, "stop %s", argv[2]);
        if (send_cmd(msg) < 0) {
            return 1;
        }
        return 0;
    }

    if ((argc == 5 || argc == 6) && strcmp(argv[1], "start") == 0) {
        ensure_daemon();
        if (argc == 6) {
            snprintf(msg, sizeof msg, "start %s %s %s %s", argv[2], argv[3], argv[4], argv[5]);
        } else {
            snprintf(msg, sizeof msg, "start %s %s %s", argv[2], argv[3], argv[4]);
        }
        return send_cmd(msg) == 0 ? 0 : 1;
    }

    usage();
    return 2;
}
