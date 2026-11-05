{ config, ... }:
let
  fm = config.flake.modules;
in
{
  # NixOS 模块按功能层级排序：启动/硬件 → 网络 → 安全 → 包管理与环境 →
  # 本地化 → 服务 → 系统级程序 → 用户层；同一层内按字母序。
  flake.modules.nixos.base = {
    imports = [
      # 启动与硬件
      fm.nixos.audio
      fm.nixos.bluetooth
      fm.nixos.boot
      fm.nixos.graphics
      fm.nixos.tuning

      # 网络
      fm.nixos.networking
      fm.nixos.proxy

      # 安全与身份
      fm.nixos.agenix
      fm.nixos.security
      fm.nixos.user

      # 包管理与环境
      fm.nixos.environment
      fm.nixos.nix
      fm.nixos.overlays

      # 本地化
      fm.nixos.fonts
      fm.nixos.i18n

      # 服务与系统
      fm.nixos.dsh
      fm.nixos.fstrim
      fm.nixos.wallpaper

      # 系统级程序
      fm.nixos.appimage

      # 用户层
      fm.nixos.home-manager
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

  # 应用级配置（home-manager）按应用名字母序
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
