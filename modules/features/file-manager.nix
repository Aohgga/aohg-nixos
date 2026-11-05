{
  flake.modules.homeManager.file-manager = { pkgs, ... }: {
    home.packages = with pkgs.kdePackages; [
      ark
      dolphin
      dolphin-plugins
      kio-extras
      kio-fuse
    ];
  };
}
