{ self, ... }:
{
  flake.modules.nixos.Legion = {
    imports = [
      self.modules.nixos.base
      self.modules.nixos.desktop
      self.modules.nixos.jellyfin
      self.modules.nixos.LegionGraphics
      self.modules.nixos.LegionHardware
      self.modules.nixos.LegionImpermanence
      self.modules.nixos.steam
    ];
    home-manager.users.aohg = {
      imports = [ self.modules.homeManager.Legion ];
    };
    networking.hostName = "Legion";
    system.stateVersion = "26.05";
  };
}
