{
  flake.modules.nixos.security = {
    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
  };
}
