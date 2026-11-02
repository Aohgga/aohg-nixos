{
  flake.modules.homeManager.theme = { pkgs, config, ... }: {
    qt = {
      enable = true;
      style = {
        package = pkgs.darkly;
      };
      platformTheme = {
        name = "kde";
      };
      kde.settings = {
        kdeglobals = {
          General = {
            XftAntialias = "true";
            XftHintStyle = "hintnone";
            XftSubPixel = "rgb";
            fixed = "Maple Mono NL NF CN,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
            font = "苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
            menuFont = "苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
            smallestReadableFont = "苹方-简,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
            toolBarFont = "苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
          };
          Icons = {
            Theme = "breeze-dark";
          };
          KDE = {
            widgetStyle = "Darkly";
          };
          WM = {
            activeFont = "苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
          };
        };
      };
    };
    gtk = {
      enable = true;
      font = {
        name = "苹方-简";
        size = 10;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        size = 20;
        package = pkgs.bibata-cursors;
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      gtk2.enable = false;
    };
    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "close,maximize,minimize,appmenu:";
      };
    };
    xdg.dataFile = {
      "themes/${config.gtk.theme.name}".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
      "icons/${config.gtk.iconTheme.name}".source = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
      "icons/${config.gtk.cursorTheme.name}".source = "${config.gtk.cursorTheme.package}/share/icons/${config.gtk.cursorTheme.name}";
    };
    home.packages = with pkgs; [
      xrdb
    ];
  };
  flake.modules.nixos.theme = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
    ] ++ ( with kdePackages; [
      kconfig
      kwidgetsaddons
    ]);
    environment.pathsToLink = [ "/share" ];
  };
}
