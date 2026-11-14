{
  flake.modules.homeManager.mpv = { config, osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".config/jellyfin-mpv-shim"
      ".config/mpv"
      ".config/mpv-handler"
      ".local/state/mpv"
    ];
    home.packages = with pkgs; [
      (mpv.override { scripts = [ bilibili-mpv mpvScripts.uosc ]; })
      mpv-handler
      yt-dlp
      jellyfin-mpv-shim
    ];
    xdg.configFile = let
      # mpv 和 jellyfin-mpv-shim 共用同一份播放配置
      mpvConf = ''
        vo=gpu-next
        hwdec=vulkan
        gpu-api=vulkan
        gpu-context=waylandvk
        profile=gpu-hq
        sub-auto=fuzzy
        osd-bar=no
        osd-font=苹方-简
        save-position-on-quit=yes
        target-colorspace-hint=no
      '';
    in {
      "mpv/mpv.conf".text = mpvConf;
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
      "jellyfin-mpv-shim/mpv.conf".text = mpvConf;
    };
  };
}
