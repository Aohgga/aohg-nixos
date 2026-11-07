{
  flake.modules.nixos.tuning = {
    hardware.steam-hardware.enable = true;
    services = {
      scx = {
        enable = true;
        scheduler = "scx_bpfland";
      };
      lact.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
      # 机械盘（/data）没有 SMART 监控
      smartd.enable = true;
    };
  };
}
