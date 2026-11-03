{ config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.Mech = {
    imports = [
      fm.nixos.base
      fm.nixos.desktop
      fm.nixos.MechHardware
      fm.nixos.MechGraphics
      fm.nixos.MechFilesystem
      fm.nixos.MechImpermanence
      fm.nixos.virtualisation
      fm.nixos.flatpak
    ];
    system.stateVersion = "26.11";
    networking.hostName = "Mech";
    home-manager.users.aohg = {
      imports = [
        fm.homeManager.base
        fm.homeManager.MechUmbriel
      ];
      home.stateVersion = "26.11";
    };
  };
}
