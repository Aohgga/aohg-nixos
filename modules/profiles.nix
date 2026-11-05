{ config, ... }:
let
  fm = config.flake.modules;
in
{
  # 所有主机共享的用户级模块
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

  # 所有主机共享的系统级模块
  flake.modules.nixos.base = {
    imports = [
      fm.nixos.agenix
      fm.nixos.appimage
      fm.nixos.audio
      fm.nixos.bluetooth
      fm.nixos.boot
      fm.nixos.dsh
      fm.nixos.environment
      fm.nixos.fonts
      fm.nixos.fstrim
      fm.nixos.graphics
      fm.nixos.home-manager
      fm.nixos.i18n
      fm.nixos.networking
      fm.nixos.nix
      fm.nixos.overlays
      fm.nixos.proxy
      fm.nixos.security
      fm.nixos.tuning
      fm.nixos.user
      fm.nixos.wallpaper
    ];
  };

  # 两台机器共用的桌面环境
  flake.modules.nixos.desktop = {
    imports = [
      fm.nixos.denial
      fm.nixos.display-manager
      fm.nixos.input-method
      fm.nixos.theme
      fm.nixos.umbriel
    ];
  };
}
