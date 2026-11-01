{
  flake.modules.nixos.user = { config, ... }: {
    sops.secrets.aohg-password = {
      sopsFile = ../../secrets/passwords.yaml;
      key = "aohg-password-hash";
      neededForUsers = true; # 关键：确保用户创建前机密已就绪
    };
    users = {
      mutableUsers = false;
      users.aohg = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "input" "video" ];
        autoSubUidGidRange = true;
        useDefaultShell = true;
        hashedPasswordFile = config.sops.secrets.aohg-password.path;
      };
    };
    services.userborn.enable = true;
  };
}
