{
  flake.modules.nixos.boot = { pkgs, ... }: {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };
      zswap.enable = false;
      plymouth.enable = true;
      consoleLogLevel = 3;
      kernelModules = [ "ntsync" ];
      kernelParams = [
        "quiet"
        "rd.udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];
      kernelPackages = pkgs.linuxPackages_latest;
      kernel.sysctl = {
        "kernel.split_lock_mitigate" = 0;
        "vm.swappiness" = 100;
        "vm.max_map_count" = 2147483642;
      };
    };
    zramSwap = {
      enable = true;
      algorithm = "lz4";
      memoryPercent = 50;
    };
    services.kmscon = {
      enable = true;
      config = {
        font-name = "Maple Mono NL NF CN";
        font-size = 22;
        hwaccel = false;
        libseat = true;
        multi-monitor = "largest";
      };
    };
  };
}
