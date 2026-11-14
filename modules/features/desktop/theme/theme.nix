{ ... }:
{
  flake-file.inputs.qtengine = {
    url = "github:kossLAN/qtengine";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.theme = { pkgs, ... }: {
    environment.pathsToLink = [ "/share" ];
    environment.systemPackages = with pkgs; [
      gsettings-desktop-schemas
      glib
      bibata-cursors
      kdePackages.kde-gtk-config
    ];

    environment.sessionVariables.GTK3_MODULES =
      "${pkgs.kdePackages.kde-gtk-config}/lib/gtk-3.0/modules/libcolorreload-gtk-module.so";

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
        { file = ".config/kdeglobals"; }
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
      platformTheme = { name = "kde"; };
      kde.settings = {
        kdeglobals = {
          General = {
            fixed = "Maple Mono NL NF CN,10";
            font = "${config.gtk.font.name},${toString config.gtk.font.size}";
            menuFont = "${config.gtk.font.name},${toString config.gtk.font.size}";
            smallestReadableFont = "${config.gtk.font.name},${toString (config.gtk.font.size - 2)}";
            toolBarFont = "${config.gtk.font.name},${toString config.gtk.font.size}";
          };
          Icons = {
            Theme = "breeze-dark";
          };
          KDE = {
            widgetStyle = "Darkly";
          };
          WM = {
            activeFont = "${config.gtk.font.name},${toString config.gtk.font.size}";
          };
        };

        kcminputrc.Mouse = {
          cursorSize = config.gtk.cursorTheme.size;
          cursorTheme = config.gtk.cursorTheme.name;
        };
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
