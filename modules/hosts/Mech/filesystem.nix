{
  flake.modules.nixos.MechFilesystem = {
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" "/home" ];
    };
    fileSystems = {
      "/".options = [ "compress=zstd:3" ];
      "/nix".options = [ "compress=zstd:3" "noatime" ];
      "/home".options = [ "compress=zstd:3" ];
    };
  };
}
