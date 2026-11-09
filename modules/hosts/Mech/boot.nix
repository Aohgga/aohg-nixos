{
  # 不是 nixos-generate-config 生成的内容，所以放在这里而不是 hardware-configuration.nix：
  # Intel 机器不需要 kvm_amd，udev 的 modalias 自动加载不读 modprobe blacklist，
  # 只写 blacklist 不够，还要用 install 规则拦掉。
  flake.modules.nixos.MechBoot = { pkgs, ... }: {
    boot.blacklistedKernelModules = [ "kvm_amd" ];
    boot.extraModprobeConfig = ''
      install kvm_amd ${pkgs.coreutils}/bin/true
    '';
  };
}
