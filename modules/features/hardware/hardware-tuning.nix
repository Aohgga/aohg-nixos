{
  flake.modules.nixos.hardware-tuning = {
    hardware.steam-hardware.enable = true;
    services = {
      scx-loader = {
        enable = true;
        config.default_sched = "scx_bpfland";
      };
      lact.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
      # 机械盘（/data）没有 SMART 监控
      smartd.enable = true;
    };
  };
}
