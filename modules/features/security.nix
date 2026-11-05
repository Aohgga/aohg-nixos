{
  flake.modules.nixos.security = {
    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
  };
}
