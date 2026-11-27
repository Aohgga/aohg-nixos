{
  flake.modules.nixos.MechFilesystem = {
    fileSystems = {
      "/".options = [ "compress=zstd:3" "x-gvfs-show" ];
      "/boot".options = [ "x-gvfs-hide" ];
      "/home".options = [ "compress=zstd:3" "x-gvfs-show" ];
      "/nix".options = [ "compress=zstd:3" "noatime" "x-gvfs-hide" ];
      "/persist-home".options = [ "x-gvfs-hide" ];
      "/persistent".options = [ "x-gvfs-hide" ];
    };
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" "/home" ];
      interval = "monthly";
    };
  };
}
