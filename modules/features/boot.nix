{
  flake.modules.nixos.boot = { pkgs, ... }: {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [
        "quiet"
        "rd.systemd.show_status=auto"
        "rd.udev.log_level=3"
      ];
      kernelModules = [ "ntsync" ];
      kernel.sysctl = {
        "kernel.split_lock_mitigate" = 0;
        "vm.max_map_count" = 2147483642;
        "vm.swappiness" = 100;
      };
      consoleLogLevel = 3;
      plymouth.enable = true;
      zswap.enable = false;
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
