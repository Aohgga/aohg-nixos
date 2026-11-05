{ inputs, ... }:
{
  # home-manager 的 NixOS 侧接入：所有主机共用
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.default ];
    home-manager = {
      backupFileExtension = "hm-backup";
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
