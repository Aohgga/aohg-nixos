{
  flake.modules.nixos.tuning = {
    hardware.steam-hardware.enable = true;
    services = {
      scx = {
        enable = true;
        scheduler = "scx_bpfland";
      };
      lact.enable = true;
      tuned = {
        enable = true;
        ppdSettings.main.default = "performance";
      };
      upower.enable = true;
      # 机械盘（/data）没有 SMART 监控
      smartd.enable = true;
    };
  };
}
