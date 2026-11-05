{
  # 两台机器共用的图形栈；GPU 差异放在 hosts/<Host>/graphics.nix
  flake.modules.nixos.graphics = { pkgs, ... }: {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        nvidia-vaapi-driver
        vulkan-loader
      ];
    };
  };
}
