{
  flake.modules.homeManager.musicfox = { osConfig, ... }: {
    home.persistence."${osConfig.aohg.persistence.homeRoot}".directories = [
      ".config/go-musicfox"
      ".local/share/go-musicfox"
      ".local/state/go-musicfox"
    ];
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
