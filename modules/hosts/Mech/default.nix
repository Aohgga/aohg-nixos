{ self, ... }:
{
  flake.modules.nixos.Mech = {
    imports = [
      self.modules.nixos.base
      self.modules.nixos.desktop
      self.modules.nixos.flatpak
      self.modules.nixos.MechFilesystem
      self.modules.nixos.MechGraphics
      self.modules.nixos.MechHardware
      self.modules.nixos.MechImpermanence
      self.modules.nixos.virtualisation
    ];
    home-manager.users.aohg = {
      imports = [ self.modules.homeManager.Mech ];
    };
    networking.hostName = "Mech";
    system.stateVersion = "26.11";
  };
}
