{
  flake.modules.homeManager.file-manager = { pkgs, ... }: {
    home.packages = with pkgs.kdePackages; [
      dolphin
      dolphin-plugins
      ark
      kio-extras
      kio-fuse
    ];
  };
}
