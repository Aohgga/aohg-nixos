{
  flake.modules.homeManager.home =
    { osConfig, ... }:
    let
      userName = osConfig.local.primaryUser.name;
    in
    {
      home.username = userName;
      home.homeDirectory = osConfig.users.users.${userName}.home;
      home.stateVersion = osConfig.system.stateVersion;

      home.sessionVariables = {
        SYSTEMD_TINT_BACKGROUND = "0";
      };

      # 不再生成 ~/.manpath
      programs.man.generateCaches = false;

      xdg.enable = true;
      xdg.userDirs.enable = true;
    };
}
