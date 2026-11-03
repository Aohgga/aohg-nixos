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
      fm.nixos.MechWallpaper
      fm.nixos.virtualisation
      fm.nixos.flatpak
      fm.nixos.dsh
    ];
    system.stateVersion = "26.11";
    networking.hostName = "Mech";
    home-manager.users.aohg = {
      imports = [
        fm.homeManager.base
        fm.homeManager.dsh
      ];
      home.stateVersion = "26.11";
    };
  };
}
