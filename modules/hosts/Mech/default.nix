{ self, ... }:
{
  flake.modules.nixos.Mech =
    { config, ... }:
    {
      imports = [
        self.modules.nixos.base

        self.modules.nixos.MechBoot
        self.modules.nixos.MechFilesystem
        self.modules.nixos.MechFonts
        self.modules.nixos.MechGraphics
        self.modules.nixos.MechHardware
        self.modules.nixos.MechImpermanence
        self.modules.nixos.MechReimsVgpu

        self.modules.nixos.desktop

        self.modules.nixos.flatpak
        self.modules.nixos.localsend
        self.modules.nixos.virtualisation
      ];
      networking.hostName = "Mech";
      system.stateVersion = "26.11";
      home-manager.users = {
        "${config.local.primaryUser.name}" = {
          imports = [ self.modules.homeManager.Mech ];
        };
      };
    };
}
