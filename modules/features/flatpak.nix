{ inputs, ... }:
{
  flake.modules.nixos.flatpak = {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
    services.flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
        {
          name = "flatpark";
          location = "https://dl.flatpark.org/flatpark.flatpakrepo";
        }
      ];
      uninstallUnmanaged = false;
      update.onActivation = false;
      overrides.global = {
        Context.filesystems = [
          "xdg-data/themes:ro"
          "xdg-config/gtk-3.0:ro"
          "xdg-config/gtk-4.0:ro"
          "/nix/store:ro"
        ];
        Environment.GTK_THEME = "adw-gtk3";
      };
    };
  };
}
