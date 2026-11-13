{ config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.base = {
    imports = [
      fm.nixos.persistence

      fm.nixos.audio
      fm.nixos.bluetooth
      fm.nixos.boot
      fm.nixos.graphics
      fm.nixos.hardware-tuning

      fm.nixos.networking
      fm.nixos.proxy

      fm.nixos.agenix
      fm.nixos.security
      fm.nixos.user

      fm.nixos.environment
      fm.nixos.nix
      fm.nixos.nrs
      fm.nixos.overlays

      fm.nixos.fonts
      fm.nixos.i18n

      fm.nixos.dsh
      fm.nixos.fstrim
      fm.nixos.journald

      fm.nixos.appimage
      fm.nixos.file-manager

      fm.nixos.home-manager
    ];
  };

  flake.modules.nixos.desktop = {
    imports = [
      fm.nixos.display-manager
      fm.nixos.input-method
      fm.nixos.theme
      fm.nixos.umbriel
    ];
  };

  flake.modules.homeManager.base = {
    imports = [
      fm.homeManager.apps
      fm.homeManager.editor
      fm.homeManager.file-manager
      fm.homeManager.fish
      fm.homeManager.input-method
      fm.homeManager.kitty
      fm.homeManager.mpv
      fm.homeManager.musicfox
      fm.homeManager.nrs
      fm.homeManager.splayer-next
      fm.homeManager.swayimg
      fm.homeManager.theme
      fm.homeManager.ttyper
      fm.homeManager.umbriel
      fm.homeManager.user
      fm.homeManager.yazi
    ];
  };
}
