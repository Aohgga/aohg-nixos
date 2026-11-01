{
  flake.modules.nixos.MechFilesystem = {
    services = {
      btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [ "/" "/home" ];
      };
      fstrim = {
        enable = true;
        interval = "weekly";
      };
    };
    fileSystems = {
      "/".options = [ "compress=zstd:3" ];
      "/nix".options = [ "compress=zstd:3" "noatime" ];
      "/home".options = [ "compress=zstd:3" ];
    };
  };
  flake.modules.nixos.LegionFilesystem = {
    services.fstrim = {
      enable = true;
      interval = "weekly";
    };
  };
}
