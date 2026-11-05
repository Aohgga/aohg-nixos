{ self, ... }:
{
  flake.modules.nixos.Legion = {
    imports = [
      self.modules.nixos.base
      self.modules.nixos.desktop
      self.modules.nixos.LegionHardware
      self.modules.nixos.LegionGraphics
      self.modules.nixos.LegionImpermanence
      self.modules.nixos.steam
      self.modules.nixos.jellyfin
    ];
    system.stateVersion = "26.05";
    networking.hostName = "Legion";
    home-manager.users.aohg = {
      imports = [ self.modules.homeManager.Legion ];
    };
  };
}
