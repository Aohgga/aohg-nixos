{ config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.Legion = {
    imports = [
      fm.nixos.base
      fm.nixos.desktop
      fm.nixos.LegionHardware
      fm.nixos.LegionGraphics
      fm.nixos.LegionFilesystem
      fm.nixos.steam
      fm.nixos.jellyfin
    ];
    system.stateVersion = "26.05";
    networking.hostName = "Legion";
    home-manager.users.aohg = {
      imports = [
        fm.homeManager.base
        fm.homeManager.LegionUmbriel
        fm.homeManager.LegionApps
        fm.homeManager.zen-browser
      ];
      home.stateVersion = "26.05";
    };
  };
}
