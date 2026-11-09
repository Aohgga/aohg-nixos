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
        age.secrets."aohg-password" = {
          file = ../../../secrets/aohg-password.age;
        };

        users = {
          mutableUsers = false;
          users.${cfg.name} = {
            isNormalUser = true;
            uid = cfg.uid;
            extraGroups = cfg.extraGroups;
            hashedPasswordFile = config.age.secrets."aohg-password".path;
            useDefaultShell = true;
            autoSubUidGidRange = true;
          };
        };
        services.userborn.enable = true;
      };
    };
}
