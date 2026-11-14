{ self, ... }:
{
  flake.modules.nixos.Legion =
    { config, ... }:
    {
      imports = [
        self.modules.nixos.base

        self.modules.nixos.LegionAudio
        self.modules.nixos.LegionBluetooth
        self.modules.nixos.LegionBoot
        self.modules.nixos.LegionFonts
        self.modules.nixos.LegionGraphics
        self.modules.nixos.LegionGreeter
        self.modules.nixos.LegionHardware
        self.modules.nixos.LegionImpermanence
        self.modules.nixos.LegionJellyfin

        self.modules.nixos.desktop

        self.modules.nixos.steam
      ];
      networking.hostName = "Legion";
      system.stateVersion = "26.05";
      home-manager.users = {
        "${config.local.primaryUser.name}" = {
          imports = [ self.modules.homeManager.Legion ];
        };
      };
    };
}
