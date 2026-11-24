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
        self.modules.nixos.LegionSwayimg

        self.modules.nixos.desktop

        self.modules.nixos.steam

        # 键盘控制指针：触控板难用时用
        self.modules.nixos.wl-kbptr
        self.modules.nixos.ydotool
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
