{ inputs, ... }:
let
  # Legion 的 nvme0n1p2（当前根分区，XFS），见 hosts/Legion/hardware-configuration.nix
  rootDevice = "/dev/disk/by-uuid/b35e382a-92d8-4a14-85f9-8e354d79ecf0";
  # 两台机器共用的持久化条目
  common = import ../../lib/persistence.nix;
in
{
  # ────────────────────────────────────────────────────────────────────────
  # tmpfs 根 + tmpfs /home，系统状态和用户状态都持久化在同一个分区
  # （nvme0n1p2）。原根分区整块挂到 /persistent，nix store 通过
  # /persistent/nix 的 bind mount 原地保留，不需要搬数据。
  # ────────────────────────────────────────────────────────────────────────
  flake.modules.nixos.LegionImpermanence = { lib, ... }: {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    fileSystems = {
      # 根：tmpfs，每次开机清空
      "/" = lib.mkForce {
        device = "none";
        fsType = "tmpfs";
        neededForBoot = true;
        options = [ "mode=0755" "size=25%" ];
      };

      # /home：tmpfs，登录后再把需要的目录 bind 回来
      "/home" = {
        device = "none";
        fsType = "tmpfs";
        neededForBoot = true;
        options = [ "mode=0755" "size=25%" ];
      };

      # 原来的根分区 = 持久化分区
      "/persistent" = {
        device = rootDevice;
        fsType = "xfs";
        neededForBoot = true;
        options = [
          "rw"
          "relatime"
          "inode64"
          "logbufs=8"
          "logbsize=32k"
          "noquota"
        ];
      };

      # nix store 还在原分区的 /nix 目录里，bind 到 /nix
      "/nix" = {
        device = "/persistent/nix";
        fsType = "none";
        neededForBoot = true;
        options = [ "bind" ];
        depends = [ "/persistent" ];
      };
    };

    # ────────────────────────────────────────────────────────────
    # machine-id 持久化
    # tmpfs 根每次开机都会生成新 machine-id，导致 journald 每个 boot
    # 建一个新目录（/var/log/journal/<id>），日志也串不起来。
    # 在 initrd 里、switch-root 之前把持久化副本 bind 到新根的
    # /etc/machine-id，这样 stage-2 的 systemd/journald 一启动看到
    # 的就是稳定 ID；也避免 impermanence persist-files 和
    # systemd-machine-id-setup 抢文件的 activation 冲突。
    # ────────────────────────────────────────────────────────────
    boot.initrd.systemd.mounts = [
      {
        where = "/sysroot/etc/machine-id";
        what = "/sysroot/persistent/etc/machine-id";
        type = "none";
        options = "bind";
        wantedBy = [ "initrd.target" ];
        before = [ "initrd-nixos-activation.service" ];
        unitConfig = {
          DefaultDependencies = false;
          Requires = [ "sysroot.mount" "sysroot-persistent.mount" ];
          After = [ "sysroot.mount" "sysroot-persistent.mount" ];
        };
      }
    ];

    # ────────────────────────────────────────────────────────────
    # 系统级持久化（root 状态）
    # ────────────────────────────────────────────────────────────
    environment.persistence."/persistent" = {
      hideMounts = true;
      # 公共系统目录 + Legion 独有
      directories = common.systemDirs ++ [
        "/etc/lact"
      ];

      # ──────────────────────────────────────────────────────────
      # 用户级持久化（home 状态）
      # 注意：home 是 tmpfs，没列在这里的东西都会在重启后消失。
      # Music / Pictures / Videos / Games / data 都指向 /data，
      # 由 home-manager 的 home.file 每次开机重建，不在这里 bind。
      # ──────────────────────────────────────────────────────────
      users.aohg = {
        directories = common.userDirs ++ [
          "Applications"
          ".config/aohg-dotfiles"
          ".config/GitHub Desktop"
          ".config/hypr"
          ".config/mozilla"
          ".config/qutebrowser"
          ".config/rofi"
          ".config/waybar"
          ".config/zen"
          ".local/share/icons"
          ".local/share/qutebrowser"
          ".local/share/Steam"
          ".steam"
        ];
        files = common.userFiles;
      };
    };
  };
}
