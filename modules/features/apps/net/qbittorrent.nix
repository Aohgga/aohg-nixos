{
  flake.modules.homeManager.qbittorrent = { osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".config/qBittorrent"
      ".local/share/qBittorrent"
    ];
    home.packages = [ pkgs.qbittorrent-enhanced ];
  };
}
