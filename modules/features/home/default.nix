{
  flake.modules.homeManager.home = {
    home.username = "aohg";
    home.homeDirectory = "/home/aohg";
    xdg = {
      enable = true;
      userDirs.enable = true;
    };
    home.sessionVariables = {
      SYSTEMD_TINT_BACKGROUND = "0";
    };
  };
}
