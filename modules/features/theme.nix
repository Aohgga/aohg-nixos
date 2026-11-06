{
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
      platformTheme = {
        name = "kde";
      };
      kde.settings.kdeglobals = {
        General = {
          fixed = "Maple Mono NL NF CN,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
          font = "苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
          menuFont = "苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
          smallestReadableFont = "苹方-简,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
          toolBarFont = "苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
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
          activeFont = "苹方-简,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,常规体,0,0";
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
    ];
    # Qt6 的 xcb 光标实现（libxcb-cursor）不读 XCURSOR_THEME，只认 Xcursor.theme
    # 资源，缺失时回退到 default 主题；建 default 继承 gtk.cursorTheme。
    home.file.".icons/default/index.theme".text = ''
      [Icon Theme]
      Inherits=${config.gtk.cursorTheme.name}
    '';
    xdg.dataFile = {
      "icons/${config.gtk.cursorTheme.name}".source = "${config.gtk.cursorTheme.package}/share/icons/${config.gtk.cursorTheme.name}";
      "icons/${config.gtk.iconTheme.name}".source = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
      "themes/${config.gtk.theme.name}".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
    };
  };
}
