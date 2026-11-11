{ inputs, self, ... }:
let
  inherit (inputs.nixpkgs) lib;
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
      modules = [
        self.modules.nixos.${host}
        ({ config, ... }: {
          assertions = [
            {
              assertion = config.networking.hostName == host;
              message = "modules/hosts/${host}: networking.hostName 必须与目录名一致";
            }
          ];
        })
      ];
    });
}
