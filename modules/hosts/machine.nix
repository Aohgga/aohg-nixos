{ inputs, self, ... }:
let
  inherit (inputs.nixpkgs) lib;
  # 主机即目录：modules/hosts/<Host>/default.nix 定义 flake.modules.nixos.<Host>。
  # 新增主机只需要建目录，不用改这里。
  hostNames = lib.sort builtins.lessThan (
    builtins.attrNames (
      lib.filterAttrs
        (name: type: type == "directory" && builtins.pathExists (./. + "/${name}/default.nix"))
        (builtins.readDir ./.)
    )
  );
in
{
  flake.nixosConfigurations = lib.genAttrs hostNames (host:
    lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ self.modules.nixos.${host} ];
    });
}
