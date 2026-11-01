{
  flake.modules.homeManager.musicfox = {
    programs.go-musicfox = {
      enable = true;
      settings = {
        startup = {
          checkUpdate = false;
        };
        main = {
          visualizer = {
            enable = true;
          };
          notification = {
            enable = false;
          };
        };
        theme = {
          activeTheme = "Transparent";
        };
        player = {
          engine = "auto";
          songLevel = "lossless";
          beep = {
            gapless = true;
          };
        };
        reporter.netease = {
          enable = false;
        };
      };
    };
  };
}
