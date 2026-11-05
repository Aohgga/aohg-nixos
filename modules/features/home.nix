{
  flake.modules.homeManager.home = {
    home.username = "aohg";
    home.homeDirectory = "/home/aohg";
    home.sessionVariables = {
      SYSTEMD_TINT_BACKGROUND = "0";
    };

    # 不再生成 ~/.manpath
    programs.man.generateCaches = false;

    xdg.enable = true;
    xdg.userDirs.enable = true;
  };
}
