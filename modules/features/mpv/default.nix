{
  flake.modules.homeManager.mpv = { pkgs, config, ... }: {
    programs.mpv = {
      enable = true;
      scripts = with pkgs; [
        mpvScripts.uosc
        bilibili-mpv
      ];
      scriptOpts = {
        uosc = {
          scale = "1.3";
          languages = "slang,zh-hans";
          top_bar_controls = "left";
        };
      };
      config = {
        vo = "gpu-next";
        profile = "gpu-hq";
        hwdec = "vulkan";
        gpu-api = "vulkan";
        gpu-context = "waylandvk";

        sub-auto = "fuzzy";

        osd-bar = false;
        osd-font = "苹方-简";

        save-position-on-quit = true;
        volume-max = 200;
      };
    };
    programs.yt-dlp.enable = true;
    home.packages = with pkgs; [
      mpv-handler
    ];
    xdg.configFile."mpv-handler/config.toml".text = ''
      mpv = "${config.home.profileDirectory}/bin/mpv"
      ytdl = "${pkgs.yt-dlp}/bin/yt-dlp"
      proxy = "http://127.0.0.1:7890"
    '';
  };
}
