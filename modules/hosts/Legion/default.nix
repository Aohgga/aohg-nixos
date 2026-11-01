{ config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.LegionConfiguration = {
    system.stateVersion = "26.05";
    networking.hostName = "Legion";
    imports = [
      fm.nixos.LegionHardware
      fm.nixos.home-manager
      fm.nixos.boot
      fm.nixos.environment
      fm.nixos.LegionFilesystem
      fm.nixos.fonts
      fm.nixos.i18n
      fm.nixos.networking
      fm.nixos.nix
      fm.nixos.security
      fm.nixos.user
      fm.nixos.audio
      fm.nixos.bluetooth
      fm.nixos.LegionGraphics
      fm.nixos.tuning
      fm.nixos.proxy
      fm.nixos.umbriel
      fm.nixos.denial
      fm.nixos.display-manager
      fm.nixos.input-method
      fm.nixos.theme
      fm.nixos.overlays
      fm.nixos.steam
      fm.nixos.jellyfin
      fm.nixos.sops
    ];
    home-manager.users.aohg = {
      imports = [
        fm.homeManager.home
        fm.homeManager.theme
        fm.homeManager.editor
        fm.homeManager.fish
        fm.homeManager.kitty
        fm.homeManager.ttyper
        fm.homeManager.yazi
        fm.homeManager.mpv
        fm.homeManager.musicfox
        fm.homeManager.file-manager
        fm.homeManager.apps
        fm.homeManager.LegionApps
        fm.homeManager.zen-browser
      ];
      home.stateVersion = "26.05";
    };
  };
}
