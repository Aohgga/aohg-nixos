{
  flake.modules.homeManager.apps = { pkgs, ... }: {
    home.packages = with pkgs; [
      app2unit
      tree
      btop
      wget
      fastfetch
      resources
      nvtopPackages.full
      wiremix
      jq
      swayimg
      qbittorrent-enhanced
      android-tools
      wev
      quickemu
      fetch
    ];
  };
}
