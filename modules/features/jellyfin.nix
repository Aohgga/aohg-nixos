{
  flake.modules.nixos.jellyfin = {
    services.jellyfin = {
      cacheDir = "/data/jellyfin/cache";
      # 媒体库和元数据都放 /data（机械盘），系统盘只留 Nix store
      dataDir = "/data/jellyfin";
      enable = true;
      openFirewall = true;
      user = "aohg";
    };
  };
}
