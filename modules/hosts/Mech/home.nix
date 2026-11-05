{ self, ... }:
{
  flake.modules.homeManager.Mech = {
    imports = [
      self.modules.homeManager.base
      self.modules.homeManager.MechUmbriel
    ];
    home.stateVersion = "26.11";
  };
}
