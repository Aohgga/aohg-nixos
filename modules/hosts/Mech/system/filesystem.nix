{
  flake.modules.nixos.MechFilesystem = {
    fileSystems = {
      "/".options = [ "compress=zstd:3" ];
      "/home".options = [ "compress=zstd:3" ];
      "/nix".options = [ "compress=zstd:3" "noatime" ];
    };
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" "/home" ];
      interval = "monthly";
    };
  };
}
