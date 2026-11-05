{ self, ... }:
{
  flake.modules.nixos.Mech = {
    imports = [
      self.modules.nixos.base
      self.modules.nixos.desktop
      self.modules.nixos.MechHardware
      self.modules.nixos.MechGraphics
      self.modules.nixos.MechFilesystem
      self.modules.nixos.MechImpermanence
      self.modules.nixos.virtualisation
      self.modules.nixos.flatpak
    ];
    system.stateVersion = "26.11";
    networking.hostName = "Mech";
    home-manager.users.aohg = {
      imports = [ self.modules.homeManager.Mech ];
    };
  };
}
