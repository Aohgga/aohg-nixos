{
  flake.modules.homeManager.mpv = { config, lib, osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".config/mpv"
      ".config/mpv-handler"
      ".local/state/mpv"
    ];
    home.packages = with pkgs; [
      (mpv.override { scripts = [ bilibili-mpv mpvScripts.uosc ]; })
      mpv-handler
      yt-dlp
    ];
    xdg.configFile = {
      "mpv/mpv.conf".text = ''
        vo=gpu-next
        hwdec=vulkan
        gpu-api=vulkan
        gpu-context=waylandvk
        profile=gpu-hq
        sub-auto=fuzzy
        osd-bar=no
        osd-font=苹方-简
        save-position-on-quit=yes
      '';
      "mpv/script-opts/uosc.conf".text = ''
        languages=slang,zh-hans
        scale=1.3
        top_bar_controls=left
      '';
      "mpv-handler/config.toml".text = ''
        mpv = "${config.home.profileDirectory}/bin/mpv"
        ytdl = "${pkgs.yt-dlp}/bin/yt-dlp"
        proxy = "${osConfig.networking.proxy.default}"
      '';
    };

    # 文件管理器（luciole/yazi 经 xdg-open）会读 mpv.desktop 的
    # --player-operation-mode=pseudo-gui（即 --idle），播放完不退出；
    # 覆盖成普通模式，让播放结束即关闭。
    xdg.dataFile."applications/mpv.desktop".text =
      lib.replaceStrings
        [ "Exec=mpv --player-operation-mode=pseudo-gui -- %U" ]
        [ "Exec=mpv -- %U" ]
        (builtins.readFile "${pkgs.mpv}/share/applications/mpv.desktop");
  };
}
