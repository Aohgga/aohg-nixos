{
  flake.modules.nixos.boot = { pkgs, ... }: {
    boot = {
      consoleLogLevel = 3;
      kernel.sysctl = {
        "kernel.split_lock_mitigate" = 0;
        "vm.max_map_count" = 2147483642;
        "vm.swappiness" = 100;
      };
      kernelModules = [ "ntsync" ];
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [
        "quiet"
        "rd.systemd.show_status=auto"
        "rd.udev.log_level=3"
      ];
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };
        timeout = 0;
      };
      plymouth.enable = true;
      zswap.enable = false;
    };
    services.kmscon = {
      config = {
        font-name = "Maple Mono NL NF CN";
        font-size = 22;
        hwaccel = false;
        libseat = true;
        multi-monitor = "largest";
      };
      enable = true;
    };
    zramSwap = {
      algorithm = "lz4";
      enable = true;
      memoryPercent = 50;
    };
  };
}
