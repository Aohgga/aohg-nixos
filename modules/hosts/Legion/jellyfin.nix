{
  # 媒体库和元数据都放 /data（机械盘），系统盘只留 Nix store
  flake.modules.nixos.LegionJellyfin = { config, ... }: {
    services.jellyfin = {
      enable = true;
      user = config.local.primaryUser.name;
      dataDir = "/data/jellyfin";
      cacheDir = "/data/jellyfin/cache";
      openFirewall = true;
    };
  };
}
