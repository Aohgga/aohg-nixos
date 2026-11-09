{
  # 媒体库和元数据都放 /data（机械盘），系统盘只留 Nix store
  flake.modules.nixos.LegionJellyfin = {
    services.jellyfin = {
      dataDir = "/data/jellyfin";
      cacheDir = "/data/jellyfin/cache";
    };
  };
}
