{ inputs, ... }:
{
  flake.modules.nixos.MechImpermanence = { config, lib, utils, ... }:
    let
      # 与 hardware-configuration.nix 同源，换盘只改那一处
      rootDevice = config.fileSystems."/".device;
      homeDevice = config.fileSystems."/home".device;

      wipeSubvolume =
        { device, mountDir, subvolume, oldDir }:
        {
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          wantedBy = [ "initrd.target" ];
          before = [ "sysroot.mount" ];
          requires = [ "${utils.escapeSystemdPath device}.device" ];
          after = [
            "${utils.escapeSystemdPath device}.device"
            "local-fs-pre.target"
          ];
          script = ''
            mkdir -p ${mountDir}
            mount ${device} ${mountDir}
            trap 'umount ${mountDir}' EXIT

            if [[ -e ${mountDir}/${subvolume} ]]; then
              mkdir -p ${mountDir}/${oldDir}
              timestamp=$(date --date="@$(stat -c %Y ${mountDir}/${subvolume})" "+%Y-%m-%d_%H:%M:%S")
              mv ${mountDir}/${subvolume} "${mountDir}/${oldDir}/$timestamp"
            fi

            for i in $(find ${mountDir}/${oldDir}/ -mindepth 1 -maxdepth 1 -mtime +14); do
              btrfs subvolume delete --recursive "$i"
            done

            btrfs subvolume create ${mountDir}/${subvolume}
          '';
        };
    in
    {
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

      boot.initrd.systemd.services = {
        wipe-root = wipeSubvolume {
          device = rootDevice;
          mountDir = "/btrfs_tmp";
          subvolume = "root";
          oldDir = "old_roots";
        };
        wipe-home-root = wipeSubvolume {
          device = homeDevice;
          mountDir = "/home_btrfs_tmp";
          subvolume = "home-root";
          oldDir = "old_home_roots";
        };
      };

      # swap 由 zram-generator 提供，不用磁盘 swap
      swapDevices = lib.mkForce [ ];

      # 注意：/etc/machine-id、/etc/adjtime 不做 `files` 持久化。
      # impermanence 的 persist-files 在 /etc 已有同名文件时会让 activation 失败，
      # 而这两项都可以在启动时重新生成（machine-id 每次 boot 会变）。

      # 自定义选项（来自 features/persistence.nix）：Mech 的家目录持久化在
      # /persist-home（btrfs 子卷），系统级持久化在 /persistent。
      aohg.persistence.homeRoot = "/persist-home";

      environment.persistence."/persistent".hideMounts = true;

      environment.persistence."/persist-home" = {
        hideMounts = true;

        users.aohg.directories = [
          ".config/VirtualBox"
          ".local/share/backgrounds"
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
