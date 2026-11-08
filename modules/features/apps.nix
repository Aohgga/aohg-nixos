{
  flake.modules.nixos.apps = {
    aohg.persistence.home.directories = [
      ".android"
      ".config/btop"
      ".config/qBittorrent"
      ".local/share/qBittorrent"
      ".local/share/umu"
    ];
  };

  flake.modules.homeManager.apps = { pkgs, ... }: {
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
