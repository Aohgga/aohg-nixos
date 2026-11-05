{
  flake.modules.nixos.user = { config, ... }: {
    age.secrets.aohg-password = {
      file = ../../secrets/passwords/aohg-password.age;
    };
    users = {
      mutableUsers = false;
      users.aohg = {
        autoSubUidGidRange = true;
        extraGroups = [ "input" "networkmanager" "video" "wheel" ];
        hashedPasswordFile = config.age.secrets.aohg-password.path;
        isNormalUser = true;
        useDefaultShell = true;
      };
    };
    services.userborn.enable = true;
  };
}
