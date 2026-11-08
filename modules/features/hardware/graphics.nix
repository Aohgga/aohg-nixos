{
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
