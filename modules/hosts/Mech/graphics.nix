{
  flake.modules.nixos.MechGraphics = { config, ... }: {
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = true;
      modesetting.enable = true;
      nvidiaSettings = false;
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
