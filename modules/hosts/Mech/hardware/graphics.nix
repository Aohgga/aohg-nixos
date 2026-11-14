{
  flake.modules.nixos.MechGraphics = { config, pkgs, ... }: {
    hardware = {
      graphics = {
        enable = true;
        extraPackages = [ pkgs.vulkan-loader ];
      };
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        open = true;
        modesetting.enable = true;
        nvidiaSettings = false;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
      };
    };

    # 单显卡：Vulkan/VAAPI 只走 NVIDIA，避免回落到软件渲染
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
    };

    services.xserver = {
      enable = false;
      videoDrivers = [ "nvidia" ];
    };
  };
}
