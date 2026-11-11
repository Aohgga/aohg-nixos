{
  flake.modules.homeManager.apps = { osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".android"
      ".config/btop"
      ".config/qBittorrent"
      ".local/share/qBittorrent"
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
      qbittorrent-enhanced
      quickemu
      resources
      tree
      wev
      wget
      wiremix
    ];
  };
}
