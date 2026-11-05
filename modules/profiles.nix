{ config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.base = {
    imports = [
      fm.nixos.audio
      fm.nixos.bluetooth
      fm.nixos.boot
      fm.nixos.graphics
      fm.nixos.tuning

      fm.nixos.networking
      fm.nixos.proxy

      fm.nixos.agenix
      fm.nixos.security
      fm.nixos.user

      fm.nixos.environment
      fm.nixos.nix
      fm.nixos.overlays

      fm.nixos.fonts
      fm.nixos.i18n

      fm.nixos.dsh
      fm.nixos.fstrim
      fm.nixos.wallpaper

      fm.nixos.appimage

      fm.nixos.home-manager
    ];
  };

  flake.modules.nixos.desktop = {
    imports = [
      fm.nixos.denial
      fm.nixos.display-manager
      fm.nixos.input-method
      fm.nixos.theme
      fm.nixos.umbriel
    ];
  };

  flake.modules.homeManager.base = {
    imports = [
      fm.homeManager.apps
      fm.homeManager.dsh
      fm.homeManager.editor
      fm.homeManager.file-manager
      fm.homeManager.fish
      fm.homeManager.home
      fm.homeManager.kitty
      fm.homeManager.mpv
      fm.homeManager.musicfox
      fm.homeManager.theme
      fm.homeManager.ttyper
      fm.homeManager.umbriel
      fm.homeManager.wallpaper
      fm.homeManager.yazi
    ];
  };
}
