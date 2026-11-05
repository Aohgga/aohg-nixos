{
  flake.modules.nixos.security = {
    programs.seahorse.enable = true;
    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };
    services.gnome.gnome-keyring.enable = true;
  };
}
