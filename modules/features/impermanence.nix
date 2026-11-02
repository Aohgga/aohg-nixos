{ inputs, ... }:
let
  # ── 设备 UUID（与 hardware-configuration.nix 一致）──
  rootDevice = "/dev/disk/by-uuid/cbada62e-5ebd-4b9d-8a3f-a71a6a75ed98";
  homeDevice = "/dev/disk/by-uuid/a7d1b984-7af8-49f4-aefb-aa5f53a6c59b";
in
{
  flake.modules.nixos.MechImpermanence = { utils, ... }: {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    # ────────────────────────────────────────────
    # 1. 持久化存储池挂载
    # ────────────────────────────────────────────

    # /persistent：root 盘上的系统级持久化
    fileSystems."/persistent" = {
      device = rootDevice;
      fsType = "btrfs";
      options = [ "subvol=persistent" ];
      neededForBoot = true;
    };

    # /persist-home：home 盘上的用户级持久化
    fileSystems."/persist-home" = {
      device = homeDevice;
      fsType = "btrfs";
      options = [ "subvol=home-persist" ];
      neededForBoot = true;
    };

    # ────────────────────────────────────────────
    # 2. initrd 阶段：每次启动重置 root 和 home-root 子卷
    # ────────────────────────────────────────────

    boot.initrd.systemd = {

      # 重置根子卷
      services.wipe-root = {
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        wantedBy = [ "initrd.target" ];
        before = [ "sysroot.mount" ];
        requires = [ "${utils.escapeSystemdPath rootDevice}.device" ];
        after = [
          "${utils.escapeSystemdPath rootDevice}.device"
          "local-fs-pre.target"
        ];
        script = ''
          mkdir /btrfs_tmp
          mount ${rootDevice} /btrfs_tmp
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

      # 重置 hoom-root 子卷
      services.wipe-home-root = {
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        wantedBy = [ "initrd.target" ];
        before = [ "sysroot.mount" ];
        requires = [ "${utils.escapeSystemdPath homeDevice}.device" ];
        after = [
          "${utils.escapeSystemdPath homeDevice}.device"
          "local-fs-pre.target"
        ];
        script = ''
          mkdir /home_btrfs_tmp
          mount ${homeDevice} /home_btrfs_tmp
          trap 'umount /home_btrfs_tmp' EXIT

          if [[ -e /home_btrfs_tmp/home-root ]]; then
            mkdir -p /home_btrfs_tmp/old_home_roots
            timestamp=$(date --date="@$(stat -c %Y /home_btrfs_tmp/home-root)" "+%Y-%m-%d_%H:%M:%S")
            mv /home_btrfs_tmp/home-root "/home_btrfs_tmp/old_home_roots/$timestamp"
          fi

          for i in $(find /home_btrfs_tmp/old_home_roots/ -maxdepth 1 -mtime +30); do
            btrfs subvolume delete --recursive "$i"
          done

          btrfs subvolume create /home_btrfs_tmp/home-root
        '';
      };
    };

    # ────────────────────────────────────────────
    # 3. 系统级持久化（root 盘的 /persistent）
    # ────────────────────────────────────────────

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

    # ────────────────────────────────────────────
    # 4. 用户级持久化（home 盘的 /persist-home）
    #    注意：impermanence 的 users.<name> 存储路径固定为
    #    /persist-home/home/aohg，不能改成 /persist-home/aohg
    # ────────────────────────────────────────────

    environment.persistence."/persist-home" = {
      hideMounts = true;
      users.aohg = {
        directories = [
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
          "Music"
          "Desktop"
          "Games"
          "AppImages"
          "Quickemu"
          "VirtualBox VMs"
          "Projects"
          ".ssh"
          ".gnupg"
          ".config"
          ".local/share"
          ".local/state"
          ".android"
          ".var/app"
        ];
        files = [
          ".bash_history"
          ".gitconfig"
        ];
      };
    };
  };
}
