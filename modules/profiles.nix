{ config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.base = {
    imports = [
      # system/storage
      fm.nixos.persistence
      fm.nixos.fstrim
      fm.nixos.journald

      # system/boot
      fm.nixos.boot

      # system/services
      fm.nixos.hardware-tuning
      fm.nixos.dsh
      fm.nixos.appimage

      # system/network
      fm.nixos.networking
      fm.nixos.proxy

      # system/security
      fm.nixos.agenix
      fm.nixos.security

      # system/core
      fm.nixos.user
      fm.nixos.environment
      fm.nixos.nix
      fm.nixos.overlays
      fm.nixos.home-manager

      # system/tools
      fm.nixos.nrs

      # system/locale
      fm.nixos.i18n

      # desktop/theme
      fm.nixos.fonts

      # apps
      fm.nixos.file-manager
      fm.nixos.localsend
    ];
  };

  flake.modules.nixos.desktop = {
    imports = [
      # desktop/display
      fm.nixos.display-manager
      fm.nixos.umbriel

      # desktop/input
      fm.nixos.input-method

      # desktop/theme
      fm.nixos.theme
    ];
  };

  flake.modules.homeManager.base = {
    imports = [
      # apps/term
      fm.homeManager.fish
      fm.homeManager.kitty
      fm.homeManager.ttyper
      fm.homeManager.yazi

      # apps/media
      fm.homeManager.mpv
      fm.homeManager.musicfox
      fm.homeManager.splayer-next
      fm.homeManager.swayimg

      # apps/cli
      fm.homeManager.cli

      # apps/editor
      fm.homeManager.editor

      # apps/file
      fm.homeManager.file-manager

      # apps/game
      fm.homeManager.prismlauncher

      # apps/net
      fm.homeManager.qbittorrent

      # desktop/display
      fm.homeManager.umbriel

      # desktop/input
      fm.homeManager.input-method

      # desktop/theme
      fm.homeManager.theme

      # system/core
      fm.homeManager.user

      # system/tools
      fm.homeManager.nrs
    ];
  };
}
