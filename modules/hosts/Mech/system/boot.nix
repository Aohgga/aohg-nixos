{
  flake.modules.nixos.MechBoot = { pkgs, ... }: {
    # 不是 nixos-generate-config 生成的内容：
    # Intel 机器不需要 kvm_amd，udev 的 modalias 自动加载不读 modprobe blacklist，
    # 只写 blacklist 不够，还要用 install 规则拦掉。
    boot.blacklistedKernelModules = [ "kvm_amd" ];
    boot.extraModprobeConfig = ''
      install kvm_amd ${pkgs.coreutils}/bin/true
    '';

    # services.xserver.enable = false 时 nixpkgs 不会把 nvidia 模块加进
    # boot.kernelModules，nvidia-drm 只能等 udev 冷插拔，greetd 会抢在 GPU
    # 就绪前启动自动登录。显式在 early boot 加载，保证设备已存在。
    boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm" ];
  };
}
