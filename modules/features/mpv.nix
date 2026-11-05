{
  flake.modules.homeManager.mpv = { config, pkgs, ... }: {
    home.packages = with pkgs; [
      mpv-handler
    ];
    programs.mpv = {
      config = {
        gpu-api = "vulkan";
        gpu-context = "waylandvk";
        hwdec = "vulkan";
        osd-bar = false;
        osd-font = "苹方-简";
        profile = "gpu-hq";
        save-position-on-quit = true;
        sub-auto = "fuzzy";
        vo = "gpu-next";
        volume-max = 200;
      };
      enable = true;
      scriptOpts.uosc = {
        languages = "slang,zh-hans";
        scale = "1.3";
        top_bar_controls = "left";
      };
      scripts = with pkgs; [
        bilibili-mpv
        mpvScripts.uosc
      ];
    };
    programs.yt-dlp.enable = true;
    xdg.configFile."mpv-handler/config.toml".text = ''
      mpv = "${config.home.profileDirectory}/bin/mpv"
      ytdl = "${pkgs.yt-dlp}/bin/yt-dlp"
      proxy = "http://127.0.0.1:7890"
    '';
  };
}
