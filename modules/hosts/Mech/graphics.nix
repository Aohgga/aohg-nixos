{
  flake.modules.nixos.MechGraphics = { config, ... }: {
    # services.xserver.enable = false 时 nixpkgs 不会把 nvidia 模块加进
    # boot.kernelModules，nvidia-drm 只能等 udev 冷插拔，greetd 会抢在 GPU
    # 就绪前启动自动登录。显式在 early boot 加载，保证设备已存在。
    boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm" ];
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
