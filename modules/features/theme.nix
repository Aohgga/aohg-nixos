{
  flake.modules.homeManager.theme = { config, pkgs, ... }:
    let
      # KDE/Qt 的字体串格式：family,size,...,style，重复写容易出错，集中定义
      monoFont = "Maple Mono NL NF CN,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      smallFont = "苹方-简,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
      uiFont = "苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
    in {
      dconf.settings = {
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "close,maximize,minimize,appmenu:";
        };
      };
      gtk = {
        cursorTheme = {
          name = "Bibata-Modern-Ice";
          package = pkgs.bibata-cursors;
          size = 20;
        };
        enable = true;
        font = {
          name = "苹方-简";
          size = 10;
        };
        gtk2.enable = false;
        iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
      };
      home.packages = with pkgs; [
        xrdb
      ];
      qt = {
        enable = true;
        kde.settings.kdeglobals = {
          General = {
            fixed = monoFont;
            font = uiFont;
            menuFont = uiFont;
            smallestReadableFont = smallFont;
            toolBarFont = uiFont;
            XftAntialias = "true";
            XftHintStyle = "hintnone";
            XftSubPixel = "rgb";
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
        platformTheme = {
          name = "kde";
        };
        style = {
          package = pkgs.darkly;
        };
      };
      xdg.dataFile = {
        "icons/${config.gtk.cursorTheme.name}".source = "${config.gtk.cursorTheme.package}/share/icons/${config.gtk.cursorTheme.name}";
        "icons/${config.gtk.iconTheme.name}".source = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
        "themes/${config.gtk.theme.name}".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
      };
    };

  flake.modules.nixos.theme = { pkgs, ... }: {
    # 保留：部分 KDE 应用依赖 /share 下的翻译/服务文件才能正常显示中文
    environment.pathsToLink = [ "/share" ];
    # greeter 用户读不到 ~/.local/share/icons 里的光标主题，
    # 必须装到系统级 /run/current-system/sw/share/icons 才能在登录界面显示光标。
    environment.systemPackages = with pkgs; [
      bibata-cursors
    ] ++ (with pkgs.kdePackages; [
      breeze
      kconfig
      kwidgetsaddons
    ]);
  };
}
