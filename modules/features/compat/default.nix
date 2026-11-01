{ inputs, ... }:
{
  flake.modules.nixos.compat = { pkgs, ... }: {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
    services.flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://mirror.sjtu.edu.cn/flathub";
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
