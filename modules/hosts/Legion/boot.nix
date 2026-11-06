{
  # 不是 nixos-generate-config 生成的内容，所以放在这里而不是 hardware-configuration.nix：
  # 用 NVIDIA 闭源驱动，屏蔽 nouveau；Legion 的 ideapad_laptop 会和电源管理冲突。
  flake.modules.nixos.LegionBoot = { pkgs, ... }: {
    boot.blacklistedKernelModules = [ "ideapad_laptop" "nouveau" ];
    # legacy_580 跟不上 mainline：跟 LTS 内核，减少内核与驱动一起重编的次数。
    boot.kernelPackages = pkgs.linuxPackages;
  };
}
