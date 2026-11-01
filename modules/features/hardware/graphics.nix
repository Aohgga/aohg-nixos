{
  flake.modules.nixos.MechGraphics = { config, pkgs, ... }: {
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          vulkan-loader
          intel-media-driver
          nvidia-vaapi-driver
        ];
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
        open = true;
        nvidiaSettings = false;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };
    };
    services.xserver = {
      enable = false;
      videoDrivers = [ "nvidia" ];
    };
  };
  flake.modules.nixos.LegionGraphics = { config, pkgs, ... }: {
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          vulkan-loader
          intel-media-driver
          nvidia-vaapi-driver
        ];
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement = { enable = false; finegrained = false; };
        nvidiaSettings = false;
        open = false;
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        prime = {
          intelBusId = "PCI:0@0:2:0";
          nvidiaBusId = "PCI:1@0:0:0";
        };
      };
    };
    services.xserver = {
      enable = false;
      videoDrivers = [ "modesetting" "nvidia" ];
    };
  };
}
