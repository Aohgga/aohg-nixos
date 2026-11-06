{ inputs, ... }:
let
  # 与 hardware-configuration.nix 的根/家分区 UUID 保持一致
  rootDevice = "/dev/disk/by-uuid/cbada62e-5ebd-4b9d-8a3f-a71a6a75ed98";
  homeDevice = "/dev/disk/by-uuid/a7d1b984-7af8-49f4-aefb-aa5f53a6c59b";
in
{
  flake.modules.nixos.MechImpermanence = { utils, ... }: {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    fileSystems."/persistent" = {
      device = rootDevice;
      fsType = "btrfs";
      options = [
        "subvol=persistent"
        "compress=zstd:3"
        "noatime"
      ];
      neededForBoot = true;
    };

    fileSystems."/persist-home" = {
      device = homeDevice;
      fsType = "btrfs";
      options = [
        "subvol=home-persist"
        "compress=zstd:3"
        "noatime"
      ];
      neededForBoot = true;
    };

    boot.initrd.systemd = {

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

    # 注意：/etc/machine-id、/etc/adjtime 不做 `files` 持久化。
    # impermanence 的 persist-files 在 /etc 已有同名文件时会让 activation 失败，
    # 而这两项都可以在启动时重新生成（machine-id 每次 boot 会变）。

    aohg.persistence.homeRoot = "/persist-home";

    environment.persistence."/persistent" = {
      hideMounts = true;
      directories = [ "/var/lib/flatpak" ];
    };

    environment.persistence."/persist-home" = {
      hideMounts = true;

      users.aohg.directories = [
        ".config/VirtualBox"
        ".local/share/backgrounds"
        ".local/share/flatpak"
        ".var/app"
        "AppImages"
        "Archive"
        "Documents"
        "Downloads"
        "Games"
        "Music"
        "Pictures"
        "Videos"
        "VMs"
      ];
    };
  };
}
