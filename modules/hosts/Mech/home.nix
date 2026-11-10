{ self, ... }:
{
  flake.modules.homeManager.Mech = {
    imports = [
      self.modules.homeManager.base
      self.modules.homeManager.helium
      self.modules.homeManager.MechUmbriel
    ];
  };
}
