{
  flake.modules.nixos.LegionGraphics = { config, pkgs, ... }: {
    hardware = {
      # nvidia-vaapi-driver 由 hardware.nvidia.videoAcceleration 默认提供
      graphics = {
        enable = true;
        extraPackages = [
          pkgs.intel-media-driver
          pkgs.vulkan-loader
        ];
      };
      nvidia = {
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
    };

    # 8 代 i5（Gen9.5）走 iHD 做 VAAPI 硬解，Vulkan 不指定 ICD，Intel/NVIDIA 都在
    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

    services.xserver = {
      enable = false;
      videoDrivers = [ "modesetting" "nvidia" ];
    };
  };
}
