{ inputs, self, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  flake.nixosConfigurations = lib.genAttrs [ "Mech" "Legion" ] (host:
    lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ self.modules.nixos.${host} ];
    });
}
