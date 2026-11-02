{
  flake.modules.nixos.user = { config, ... }: {
    age.secrets.aohg-password = {
      file = ../../secrets/passwords/aohg-password.age;
    };
    users = {
      mutableUsers = false;
      users.aohg = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "input" "video" ];
        autoSubUidGidRange = true;
        useDefaultShell = true;
        hashedPasswordFile = config.age.secrets.aohg-password.path;
      };
    };
    services.userborn.enable = true;
  };
}
