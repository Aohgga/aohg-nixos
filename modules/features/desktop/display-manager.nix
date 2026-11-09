{
  flake.modules.nixos.display-manager = { config, ... }: {
    services.displayManager = {
      plasma-login-manager.enable = true;
      autoLogin = {
        enable = true;
        user = config.local.primaryUser.name;
      };
      defaultSession = "umbriel";
    };

    local.persistence = {
      home.directories = [ ".local/share/plasmalogin" ];
      system.directories = [ "/var/lib/plasmalogin" ];
    };
  };
}
