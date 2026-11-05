{
  flake.modules.nixos.tuning = {
    hardware.steam-hardware.enable = true;
    services = {
      lact.enable = true;
      scx = {
        enable = true;
        scheduler = "scx_bpfland";
      };
      # 机械盘（/data）没有 SMART 监控
      smartd.enable = true;
      tuned.enable = true;
      upower.enable = true;
    };
  };
}
