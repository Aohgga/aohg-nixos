{
  flake.modules.nixos.LegionBoot = { pkgs, ... }: {
    # 不是 nixos-generate-config 生成的内容：
    # 用 NVIDIA 闭源驱动，屏蔽 nouveau；Legion 的 ideapad_laptop 会和电源管理冲突。
    boot.blacklistedKernelModules = [ "ideapad_laptop" "kvm_amd" "nouveau" ];
    # udev 的 modalias 自动加载不读 modprobe blacklist，用 install 规则拦掉。
    boot.extraModprobeConfig = ''
      install kvm_amd ${pkgs.coreutils}/bin/true
    '';
    # legacy_580 跟不上 mainline：跟 LTS 内核，减少内核与驱动一起重编的次数。
    boot.kernelPackages = pkgs.linuxPackages;

    boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm" ];
  };
}
