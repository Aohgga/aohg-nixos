{
  flake.modules.nixos.hardware-tuning = {
    hardware.steam-hardware.enable = true;
    services = {
      scx-loader = {
        enable = true;
        config.default_sched = "scx_bpfland";
      };
      power-profiles-daemon.enable = true;
      upower.enable = true;
      smartd.enable = true;
    };

    local.persistence = {
      system.directories = [
        "/var/lib/power-profiles-daemon"
        "/var/lib/upower"
      ];
    };
  };
}
