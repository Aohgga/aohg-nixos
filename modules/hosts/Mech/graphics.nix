{
  flake.modules.nixos.MechGraphics = { config, ... }: {
    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
    };
    services.xserver = {
      enable = false;
      videoDrivers = [ "nvidia" ];
    };
  };
}
