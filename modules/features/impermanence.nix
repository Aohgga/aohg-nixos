{ inputs, ... }:
{
  flake.modules.nixos.MechImpermanence = { utils, ... }: {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    boot.initrd.systemd = {
      services.wipe-root = {
        # 官方示例：显式禁用默认依赖，由 after/requires 精确控制
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        wantedBy = [ "initrd.target" ];
        # 必须在任何文件系统挂载之前完成
        before = [ "sysroot.mount" ];
        # 等待磁盘设备就绪
        requires = [
          "${utils.escapeSystemdPath "/dev/disk/by-uuid/cbada62e-5ebd-4b9d-8a3f-a71a6a75ed98"}.device"
        ];
        after = [
          "${utils.escapeSystemdPath "/dev/disk/by-uuid/cbada62e-5ebd-4b9d-8a3f-a71a6a75ed98"}.device"
          # 允许休眠恢复在修改数据前完成
          "local-fs-pre.target"
        ];
        script = ''
          mkdir /btrfs_tmp
          mount /dev/disk/by-uuid/cbada62e-5ebd-4b9d-8a3f-a71a6a75ed98 /btrfs_tmp
          trap 'umount /btrfs_tmp' EXIT

          if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            btrfs subvolume delete --recursive "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
        '';
      };
    };
    fileSystems."/persistent" = {
      device = "/dev/disk/by-uuid/cbada62e-5ebd-4b9d-8a3f-a71a6a75ed98";
      neededForBoot = true;
      fsType = "btrfs";
      options = [ "subvol=persistent" ];
    };
    environment.persistence."/persistent" = {
      hideMounts = true;
      directories = [
        "/etc"
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/var/lib/NetworkManager"
        "/var/lib/bluetooth"
        "/var/lib/private/mihomo"
        "/var/lib/flatpak"
        "/var/lib/plasmalogin"
        "/var/lib/noctalia-greeter"
        "/var/log"
        "/var/spool"
      ];
    };
    environment.persistence."/persist-home" = {
      hideMounts = true;
      users.aohg = {
        directories = [
          # ── 文档 ──
          "Documents" "Downloads" "Pictures" "Videos" "Music" "Desktop"
          "Games"
          "AppImages"
          "Quickemu"
          "VirtualBox VMs"
          # ── 项目 ──
          "Projects"
          # ── 安全 / 身份 ──
          ".ssh" ".gnupg"
          # ── 配置（按需增删）──
          ".config"
          ".local/share"
          ".local/state"
          ".android"
          # ── Flatpak 用户数据 ──
          ".var/app"
        ];
        files = [
          ".bashrc" ".zshrc" ".profile" ".bash_history" ".gitconfig"
        ];
      };
    };
  };
}
