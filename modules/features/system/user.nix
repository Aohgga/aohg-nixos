{
  flake.modules.nixos.user = { config, ... }: {
    age.secrets."aohg-password" = {
      file = ../../../secrets/aohg-password.age;
    };
    users = {
      mutableUsers = false;
      users.aohg = {
        isNormalUser = true;
        extraGroups = [ "input" "networkmanager" "video" "wheel" ];
        hashedPasswordFile = config.age.secrets."aohg-password".path;
        useDefaultShell = true;
        autoSubUidGidRange = true;
      };
    };
    services.userborn.enable = true;
  };
}
