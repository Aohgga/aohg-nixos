{ inputs, self, ... }:
let
  inherit (inputs.nixpkgs) lib;
  # 主机即目录：modules/hosts/<Host>/ 里定义 flake.modules.nixos.<Host>。
  # 新增主机只需要建目录，不用改这里。
  hostNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./.)
  );
in
{
  flake.nixosConfigurations = lib.genAttrs hostNames (host:
    lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ self.modules.nixos.${host} ];
    });
}
