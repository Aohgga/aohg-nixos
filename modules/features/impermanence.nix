{ inputs, ... }:
{
  flake.modules.nixos.MechImpermanence = { lib, ... }: {
    boot.initrd.postResumeCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/disk/by-uuid/cbada62e-5ebd-4b9d-8a3f-a71a6a75ed98 /btrfs_tmp

      if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      # 递归删除旧子卷的辅助函数（文章原样）
      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }

      # 清理 30 天前的旧根
      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
    imports = [ inputs.impermanence.nixosModules.impermanence ];
    environment.persistence."/nix/persist" = {
      hideMounts = true;
      directories = [
        # ── P0：不保留会直接出事 ──
        "/etc"                       # 密码哈希、SSH host key、系统配置
        "/var/lib/nixos"             # UID/GID 映射（userborn 依赖，丢了 UID 会变）
        "/var/lib/systemd"           # random-seed、timer 状态、machine 状态

        # ── P0：网络与代理 ──
        "/var/lib/NetworkManager"    # WiFi 密码、有线连接配置
        "/var/lib/bluetooth"         # 蓝牙配对设备、MAC 绑定
        "/var/lib/private/mihomo"    # mihomo 订阅缓存、rule-provider 缓存

        # ── P1：应用状态 ──
        "/var/lib/flatpak"           # Flatpak 应用数据（remotes 是声明式，但已装 app 的状态在这）
        "/var/lib/plasmalogin"
        "/var/lib/noctalia-greeter"

        # ── P1：日志与 spool ──
        "/var/log"                   # 系统日志（journald 持久化需要）
        "/var/spool"                 # 邮件队列、cron 状态
      ];
    };
  };
}
