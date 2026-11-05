{
  flake.modules.homeManager.musicfox = {
    programs.go-musicfox = {
      enable = true;
      settings = {
        main = {
          notification.enable = false;
          visualizer.enable = true;
        };
        player = {
          beep.gapless = true;
          engine = "auto";
          songLevel = "lossless";
        };
        reporter.netease.enable = false;
        startup.checkUpdate = false;
        theme.activeTheme = "Transparent";
      };
    };
  };
}
