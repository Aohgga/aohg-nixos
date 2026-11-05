{
  flake.modules.nixos.MechGraphics = { config, ... }: {
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = true;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
    services.xserver = {
      enable = false;
      videoDrivers = [ "nvidia" ];
    };
  };
}
