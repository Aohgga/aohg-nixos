{
  # 两台机器共用的 SSD 周期 trim
  flake.modules.nixos.fstrim = {
    services.fstrim = {
      enable = true;
      interval = "weekly";
    };
  };
}
