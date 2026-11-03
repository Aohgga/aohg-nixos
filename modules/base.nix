{ config, ... }:
let
  fm = config.flake.modules;
in
{
  # 所有主机共享的系统级模块
  flake.modules.nixos.base = {
    imports = [
      fm.nixos.home-manager
      fm.nixos.boot
      fm.nixos.environment
      fm.nixos.fonts
      fm.nixos.i18n
      fm.nixos.networking
      fm.nixos.nix
      fm.nixos.security
      fm.nixos.user
      fm.nixos.audio
      fm.nixos.bluetooth
      fm.nixos.tuning
      fm.nixos.proxy
      fm.nixos.overlays
      fm.nixos.agenix
      fm.nixos.appimage
      fm.nixos.wallpaper
      fm.nixos.dsh
    ];
  };

  # 两台机器共用的桌面环境
  flake.modules.nixos.desktop = {
    imports = [
      fm.nixos.umbriel
      fm.nixos.denial
      fm.nixos.display-manager
      fm.nixos.input-method
      fm.nixos.theme
    ];
  };

  # 所有主机共享的用户级模块
  flake.modules.homeManager.base = {
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
      fm.homeManager.wallpaper
      fm.homeManager.dsh
      fm.homeManager.umbriel
      fm.homeManager.audio
    ];
  };
}
