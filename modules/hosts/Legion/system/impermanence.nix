{ inputs, ... }:
{
  # tmpfs 根 + tmpfs /home，系统状态和用户状态都持久化在同一个分区
  # （nvme0n1p2）。原根分区整块挂到 /persistent，nix store 通过
  # /persistent/nix 的 bind mount 原地保留，不需要搬数据。
  flake.modules.nixos.LegionImpermanence = { config, lib, ... }: {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    fileSystems = {
      "/" = lib.mkForce {
        device = "none";
        fsType = "tmpfs";
        neededForBoot = true;
        options = [
          "mode=0755"
          "size=25%"
          "x-gvfs-hide"
        ];
      };

      "/home" = {
        device = "none";
        fsType = "tmpfs";
        neededForBoot = true;
        options = [
          "mode=0755"
          "size=25%"
          "x-gvfs-hide"
        ];
      };

      # 原来的根分区（nvme0n1p2，XFS）= 持久化分区
      "/persistent" = {
        device = "/dev/disk/by-uuid/b35e382a-92d8-4a14-85f9-8e354d79ecf0";
        fsType = "xfs";
        neededForBoot = true;
        options = [
          "rw"
          "relatime"
          "inode64"
          "logbufs=8"
          "logbsize=32k"
          "noquota"
          "x-gvfs-show"
        ];
      };

      # /data 是 Legion 的数据盘，显示到 GVfs；/boot 隐藏
      "/data".options = [ "x-gvfs-show" ];
      "/boot".options = [ "x-gvfs-hide" ];

      # nix store 还在原分区的 /nix 目录里，bind 到 /nix
      "/nix" = {
        device = "/persistent/nix";
        fsType = "none";
        neededForBoot = true;
        options = [ "bind" "x-gvfs-hide" ];
        depends = [ "/persistent" ];
      };
    };

    # swap 由 zram-generator 提供，不用磁盘 swap
    swapDevices = lib.mkForce [ ];

    environment.persistence."/persistent" = {
      hideMounts = true;

      users.${config.local.primaryUser.name}.directories = [
        ".aspnet"
        ".config/zen"
      ];
    };
  };
}
