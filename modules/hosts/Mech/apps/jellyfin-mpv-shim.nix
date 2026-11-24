{
  # jellyfin-mpv-shim 用 --config-dir 隔离自己的 mpv 配置，读不到 ~/.config/mpv，
  # 所以单独放一份，内容直接取自 mpv 模块写出的 mpv.conf。
  flake.modules.homeManager.MechJellyfinMpvShim = { config, osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".config/jellyfin-mpv-shim"
    ];
    home.packages = [ pkgs.jellyfin-mpv-shim ];
    xdg.configFile."jellyfin-mpv-shim/mpv.conf".text =
      config.xdg.configFile."mpv/mpv.conf".text;
  };
}
