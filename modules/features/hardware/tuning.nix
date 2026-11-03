{
  flake.modules.nixos.tuning = {
    services = {
      upower.enable  = true;
      tuned.enable   = true;
      lact.enable    = true;
      # 机械盘（/data）没有 SMART 监控
      smartd.enable  = true;
      scx = {
        enable = true;
        scheduler = "scx_bpfland";
      };
    };
    hardware.steam-hardware.enable = true;
  };
}
