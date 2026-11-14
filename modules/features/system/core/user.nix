{
  flake.modules.nixos.user =
    { config, lib, ... }:
    let
      cfg = config.local.primaryUser;
    in
    {
      options.local.primaryUser = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "aohg";
          description = "主用户名；主机可覆盖，home 路径、service 账户和持久化都从它派生。";
        };
        uid = lib.mkOption {
          type = lib.types.int;
          default = 1000;
          description = "固定 uid；改名时保持不变，否则持久化文件的属主会错位。";
        };
        extraGroups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "input" "networkmanager" "video" "wheel" ];
          description = "主用户的附加组。";
        };
      };

      config = {
        age.secrets."user-password" = {
          file = ../../../../secrets/user-password.age;
        };

        users = {
          mutableUsers = false;
          users.${cfg.name} = {
            isNormalUser = true;
            uid = cfg.uid;
            extraGroups = cfg.extraGroups;
            hashedPasswordFile = config.age.secrets."user-password".path;
            useDefaultShell = true;
            autoSubUidGidRange = true;
          };
        };
        services.userborn.enable = true;
      };
    };

  flake.modules.homeManager.user =
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

      programs.man.generateCaches = false;

      xdg.enable = true;
      xdg.userDirs.enable = true;
    };
}
