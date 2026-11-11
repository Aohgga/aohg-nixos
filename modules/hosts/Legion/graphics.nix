{
  flake.modules.nixos.LegionGraphics = { config, pkgs, ... }: {
    # services.xserver.enable = false 时 nixpkgs 不会把 nvidia 模块加进
    # boot.kernelModules，nvidia-drm 只能等 udev 冷插拔，greetd 会抢在 GPU
    # 就绪前启动自动登录。显式在 early boot 加载，保证设备已存在。
    boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm" ];
    # nvidia-vaapi-driver 由 hardware.nvidia.videoAcceleration 默认提供
    hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
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
    # 8 代 i5（Gen9.5）走 iHD 做 VAAPI 硬解，Vulkan 不指定 ICD，Intel/NVIDIA 都在
    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
    services.xserver = {
      enable = false;
      videoDrivers = [ "modesetting" "nvidia" ];
    };
  };
}
