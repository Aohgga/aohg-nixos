{
  flake.modules.homeManager.cli = { osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".android"
      ".config/btop"
      ".local/share/umu"
    ];
    home.packages = with pkgs; [
      android-tools
      app2unit
      btop
      fastfetch
      fetch
      glow
      jq
      nvtopPackages.full
      quickemu
      resources
      tree
      wev
      wget
      wiremix
    ];
  };
}
