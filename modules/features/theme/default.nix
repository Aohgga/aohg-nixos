{
  flake.modules.homeManager.theme = { pkgs, config, ... }:
    let
      # KDE/Qt 的字体串格式：family,size,...,style，重复写容易出错，集中定义
      uiFont = "苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
      smallFont = "苹方-简,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
      monoFont = "Maple Mono NL NF CN,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
    in {
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
              fixed = monoFont;
              font = uiFont;
              menuFont = uiFont;
              smallestReadableFont = smallFont;
              toolBarFont = uiFont;
            };
            Icons = {
              Theme = "breeze-dark";
            };
            KDE = {
              widgetStyle = "Darkly";
            };
            WM = {
              activeFont = uiFont;
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
    environment.systemPackages = with pkgs.kdePackages; [
      kconfig
      kwidgetsaddons
    ];
    # 保留：部分 KDE 应用依赖 /share 下的翻译/服务文件才能正常显示中文
    environment.pathsToLink = [ "/share" ];
  };
}
