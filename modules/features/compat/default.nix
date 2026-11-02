{ inputs, ... }:
{
  flake.modules.nixos.flatpak = { lib, ... }: {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
    services.flatpak = {
      enable = true;
      remotes = lib.mkOptionDefault [
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
  flake.modules.nixos.appimage = { pkgs, ... }: {
    programs.appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.libepoxy
        ];
      };
    };
  };
}
