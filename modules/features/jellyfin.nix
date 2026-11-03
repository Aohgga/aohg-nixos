{
  flake.modules.nixos.jellyfin = {
    services.jellyfin = {
      enable = true;
      # 8096/tcp、1900/udp、7359/udp 在 networking.nix 里按网段放行
      openFirewall = false;
      user = "aohg";
      # 媒体库和元数据都放 /data（机械盘），系统盘只留 Nix store
      dataDir = "/data/jellyfin";
      cacheDir = "/data/jellyfin/cache";
    };
  };
}
