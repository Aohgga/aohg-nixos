{
  # 不是 nixos-generate-config 生成的内容，所以放在这里而不是 hardware-configuration.nix：
  # 用 NVIDIA 闭源驱动，屏蔽 nouveau；Legion 的 ideapad_laptop 会和电源管理冲突。
  flake.modules.nixos.LegionBoot = {
    boot.blacklistedKernelModules = [ "ideapad_laptop" "nouveau" ];
  };
}
