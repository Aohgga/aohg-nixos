{ self, ... }:
{
  flake.modules.nixos.Mech = {
    imports = [
      self.modules.nixos.base

      self.modules.nixos.MechFilesystem
      self.modules.nixos.MechGraphics
      self.modules.nixos.MechHardware
      self.modules.nixos.MechImpermanence

      self.modules.nixos.desktop

      self.modules.nixos.flatpak
      self.modules.nixos.virtualisation
    ];
    networking.hostName = "Mech";
    system.stateVersion = "26.11";
    home-manager.users.aohg = {
      imports = [ self.modules.homeManager.Mech ];
    };
  };
}
