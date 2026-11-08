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
      overrides.global = {
        Context.filesystems = [
          "/nix/store:ro"
          "xdg-config/gtk-3.0:ro"
          "xdg-config/gtk-4.0:ro"
          "xdg-data/themes:ro"
        ];
        Environment.GTK_THEME = "adw-gtk3";
      };
      uninstallUnmanaged = false;
      update.onActivation = false;
    };

    aohg.persistence = {
      home.directories = [
        ".local/share/flatpak"
        ".var/app"
      ];
      system.directories = [ "/var/lib/flatpak" ];
    };
  };
}
