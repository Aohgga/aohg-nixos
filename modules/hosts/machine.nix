{ inputs, self, ... }:

{
  flake.nixosConfigurations = {
    Mech = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ self.modules.nixos.MechConfiguration ];
    };
    Legion = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ self.modules.nixos.LegionConfiguration ];
    };
  };
}
