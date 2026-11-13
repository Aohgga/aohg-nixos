{ inputs, ... }:
{
  flake-file.inputs = {
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    umbriel.url = "github:noctalia-dev/umbriel/cachix";
  };

  flake.modules.nixos.umbriel = { pkgs, ... }: {
    imports = [
      inputs.noctalia.nixosModules.default
      inputs.umbriel.nixosModules.default
    ];

    nix.settings = {
      substituters = [
        "https://noctalia.cachix.org"
        "https://umbriel.cachix.org"
      ];
      "trusted-public-keys" = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      ];
    };

    services.gvfs.enable = true;
    programs.dconf.enable = true;
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };
    programs.umbriel = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-umbriel;
    };
    xdg.portal.extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];

    local.persistence.home.directories = [
      ".cache/noctalia"
      ".config/noctalia"
      ".config/umbriel"
      ".config/xdg-desktop-portal"
      ".local/state/noctalia"
    ];
  };

  flake.modules.homeManager.umbriel = {
    imports = [ inputs.umbriel.homeModules.default ];
    programs.umbriel.enable = true;

    xdg.configFile."noctalia/config.toml".text = ''
      [theme]
      source = "wallpaper"
      [theme.templates.user.umbriel_gtk4]
      input_path  = "$XDG_CACHE_HOME/noctalia/umbriel-gtk4/gtk4-input.css"
      output_path = "$XDG_CONFIG_HOME/gtk-4.0/umbriel.css"
      pre_hook    = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk4/input.sh\" > /dev/null"
      post_hook   = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk4/apply.sh\""

      [theme.templates.user.umbriel_gtk3]
      input_path  = "$XDG_CACHE_HOME/noctalia/umbriel-gtk4/gtk3-buttons-input.css"
      output_path = "$XDG_CONFIG_HOME/gtk-3.0/umbriel-buttons.css"
      pre_hook    = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk4/input3.sh\" > /dev/null"
      post_hook   = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk4/apply-gtk3.sh\""

      [theme.templates.user.umbriel_firefox_buttons]
      input_path  = "$XDG_CACHE_HOME/noctalia/umbriel-gtk4/firefox-buttons-input.css"
      output_path = "$XDG_CACHE_HOME/noctalia/umbriel-gtk4/firefox-buttons.css"
      pre_hook    = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk4/firefox-input.sh\" > /dev/null"
      post_hook   = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk4/firefox-apply.sh\""

      [theme.templates.user.fcitx5_mellow_conf]
      input_path  = "~/.config/noctalia/templates/fcitx5-mellow/theme.conf"
      output_path = "$XDG_DATA_HOME/fcitx5/themes/noctalia-mellow/theme.conf"
      post_hook   = "bash \"$HOME/.config/noctalia/templates/fcitx5-mellow/apply.sh\""

      [theme.templates.user.fcitx5_mellow_panel]
      input_path  = "~/.config/noctalia/templates/fcitx5-mellow/panel.svg"
      output_path = "$XDG_DATA_HOME/fcitx5/themes/noctalia-mellow/panel.svg"

      [theme.templates.user.fcitx5_mellow_highlight]
      input_path  = "~/.config/noctalia/templates/fcitx5-mellow/highlight.svg"
      output_path = "$XDG_DATA_HOME/fcitx5/themes/noctalia-mellow/highlight.svg"
    '';

    xdg.configFile."xdg-desktop-portal/umbriel-portals.conf".text = ''
      [preferred]
      default = umbriel;gtk
      org.freedesktop.impl.portal.FileChooser = strata
    '';
  };
}
