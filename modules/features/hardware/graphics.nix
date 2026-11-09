{
  flake.modules.nixos.graphics = { pkgs, ... }: {
    hardware.graphics = {
      enable = true;
      extraPackages = [ pkgs.vulkan-loader ];
    };
  };
}
