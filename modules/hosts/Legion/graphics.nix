{
  flake.modules.nixos.LegionGraphics = { config, ... }: {
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      open = false;
      modesetting.enable = true;
      nvidiaSettings = false;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      prime = {
        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };
    services.xserver = {
      enable = false;
      videoDrivers = [ "modesetting" "nvidia" ];
    };
  };
}
