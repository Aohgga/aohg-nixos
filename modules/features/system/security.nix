{
  flake.modules.nixos.security = {
    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;

    local.persistence = {
      home.directories = [
        ".local/share/keyrings"
        ".local/share/kwalletd"
      ];
      system.directories = [ "/var/lib/AccountsService" ];
    };
  };
}
