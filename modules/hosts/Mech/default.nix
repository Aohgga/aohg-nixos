{ config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.MechConfiguration = {
    system.stateVersion = "26.11";
    networking.hostName = "Mech";
    imports = [
      fm.nixos.MechHardware
      fm.nixos.home-manager
      fm.nixos.boot
      fm.nixos.environment
      fm.nixos.MechFilesystem
      fm.nixos.fonts
      fm.nixos.i18n
      fm.nixos.networking
      fm.nixos.nix
      fm.nixos.security
      fm.nixos.user
      fm.nixos.audio
      fm.nixos.bluetooth
      fm.nixos.MechGraphics
      fm.nixos.tuning
      fm.nixos.appimage
      fm.nixos.flatpak
      fm.nixos.proxy
      fm.nixos.virtualisation
      fm.nixos.umbriel
      fm.nixos.denial
      fm.nixos.display-manager
      fm.nixos.input-method
      fm.nixos.theme
      fm.nixos.overlays
      fm.nixos.agenix
      fm.nixos.MechImpermanence
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
      ];
      home.stateVersion = "26.11";
    };
  };
}
