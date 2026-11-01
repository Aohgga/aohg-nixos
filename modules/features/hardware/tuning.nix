{
  flake.modules.nixos.tuning = {
    services = {
      upower.enable  = true;
      tuned.enable   = true;
      lact.enable    = true;
      scx = {
        enable = true;
        scheduler = "scx_bpfland";
      };
    };
    hardware.steam-hardware.enable = true;
  };
}
