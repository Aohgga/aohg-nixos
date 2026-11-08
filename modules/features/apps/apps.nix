{
  flake.modules.homeManager.apps = { osConfig, pkgs, ... }: {
    home.persistence."${osConfig.aohg.persistence.homeRoot}".directories = [
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
      jq
      nvtopPackages.full
      qbittorrent-enhanced
      quickemu
      resources
      swayimg
      tree
      wev
      wget
      wiremix
    ];
  };
}
