{
  flake.modules.nixos.musicfox = {
    aohg.persistence.home.directories = [
      ".config/go-musicfox"
      ".local/share/go-musicfox"
      ".local/state/go-musicfox"
    ];
  };

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
