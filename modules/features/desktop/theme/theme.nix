{ inputs, ... }:
{
  flake-file.inputs.qtengine = {
    url = "github:kossLAN/qtengine";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.theme = { pkgs, ... }: {
    imports = [ inputs.qtengine.nixosModules.default ];
    environment.pathsToLink = [ "/share" ];
    environment.systemPackages = with pkgs; [
      gsettings-desktop-schemas
      glib
      bibata-cursors
      kdePackages.kde-gtk-config
    ];

    environment.sessionVariables.GTK3_MODULES =
      "${pkgs.kdePackages.kde-gtk-config}/lib/gtk-3.0/modules/libcolorreload-gtk-module.so";

    programs.qtengine = {
      enable = true;
      config = {
        theme = {
          colorScheme = "/home/aohg/.local/share/color-schemes/noctalia.colors";
          iconTheme = "breeze-dark";
          style = "darkly";
          quickStyle = "org.kde.desktop";
          font = {
            family = "苹方-简";
            size = 10;
            weight = -1;
          };
          fontFixed = {
            family = "Maple Mono NL NF CN";
            size = 10;
            weight = -1;
          };
        };
        misc = {
          singleClickActivate = false;
          menusHaveIcons = true;
          shortcutsForContextMenus = true;
          dialogButtonBoxLayout = 2;
          keyboardScheme = 3;
          uiEffects = 1;
          toolButtonStyle = 3;
        };
      };
    };

    local.persistence = {
      home.directories = [
        ".cache/fontconfig"
        ".config/dconf"
        ".config/fontconfig"
        ".config/gtk-3.0"
        ".config/gtk-4.0"
        ".local/share/color-schemes"
      ];
      home.files = [
        { file = ".config/darklyrc"; }
      ];
      system.directories = [ "/var/lib/colord" ];
    };
  };

  flake.modules.homeManager.theme = { config, pkgs, ... }: {
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 20;
      };
      font = {
        name = "苹方-简";
        size = 10;
      };
      gtk2.enable = false;
    };
    qt = {
      enable = true;
      style = {
        package = pkgs.darkly;
      };
    };
    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "close,maximize,minimize,appmenu:";
      };
    };
    home.packages = with pkgs; [
      xrdb
    ] ++ (with pkgs.kdePackages; [
      kconfig
      kwidgetsaddons
    ]);
    # Qt6 的 xcb 光标实现（libxcb-cursor）不读 XCURSOR_THEME，只认 Xcursor.theme
    # 资源，缺失时回退到 default 主题；建 default 继承 gtk.cursorTheme。
    xdg.dataFile = {
      "icons/default/index.theme".text = ''
        [Icon Theme]
        Inherits=${config.gtk.cursorTheme.name}
      '';
      "icons/${config.gtk.cursorTheme.name}".source = "${config.gtk.cursorTheme.package}/share/icons/${config.gtk.cursorTheme.name}";
      "icons/${config.gtk.iconTheme.name}".source = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
      "themes/${config.gtk.theme.name}".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
    };
  };
}
