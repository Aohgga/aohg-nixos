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
          # 文件对话框交给系统的 xdg-desktop-portal 实现。
          dialogTheme = "xdgdesktopportal";
          dialogButtonBoxLayout = 2;
          keyboardScheme = 3;
          uiEffects = 1;
          toolButtonStyle = 3;
        };
      };
    };

    local.persistence = {
      # gtk-3.0/gtk-4.0 与 color-schemes 里的配色由 noctalia 登录后重渲染，不持久化。
      home.directories = [
        ".cache/fontconfig"
        ".config/dconf"
        ".config/fontconfig"
      ];
      system.directories = [ "/var/lib/colord" ];
    };
  };

  flake.modules.homeManager.theme = { config, lib, pkgs, ... }: {
    # noctalia 的全局主题层：调色板来源 + 与具体部件无关的配色模板。
    # 各应用/输入法的模板（umbriel、fcitx5、wl-kbptr、swayimg…）用 lib.mkAfter
    # 追加到这个文件末尾，所以这里必须只有一份基础文本。
    xdg.configFile."noctalia/config.toml".text = ''
      [theme]
      source = "wallpaper"

      # Papirus 文件夹配色
      [theme.templates.user.papirus]
      input_path  = "~/.config/noctalia/templates/papirus/colors"
      output_path = "~/.config/noctalia/templates/papirus/colors-final"
      post_hook   = "bash \"$HOME/.config/noctalia/templates/papirus/apply.sh\""

      # umbriel 的窗口按钮样式模板。input 由 pre_hook 从 umbriel 的 config.toml
      # 生成到缓存目录，再由 noctalia 渲染并应用到 gtk-3.0 / gtk-4.0。
      [theme.templates.user.umbriel_gtk4]
      input_path  = "$XDG_CACHE_HOME/noctalia/umbriel-gtk/gtk4-input.css"
      output_path = "$XDG_CONFIG_HOME/gtk-4.0/umbriel.css"
      pre_hook    = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk/gtk4-input.sh\" > /dev/null"
      post_hook   = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk/gtk4-apply.sh\""

      [theme.templates.user.umbriel_gtk4_extras]
      input_path  = "$XDG_CACHE_HOME/noctalia/umbriel-gtk/gtk4-extras-input.css"
      output_path = "$XDG_CONFIG_HOME/gtk-4.0/umbriel-extras.css"
      pre_hook    = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk/gtk4-input.sh\" > /dev/null"
      post_hook   = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk/gtk4-apply.sh\""

      [theme.templates.user.umbriel_gtk3]
      input_path  = "$XDG_CACHE_HOME/noctalia/umbriel-gtk/gtk3-buttons-input.css"
      output_path = "$XDG_CONFIG_HOME/gtk-3.0/colors.css"
      # colors.css 触发 libcolorreload 重载，要排在 extras 之后渲染
      index       = 2
      pre_hook    = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk/gtk3-input.sh\" > /dev/null"
      post_hook   = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk/gtk3-apply.sh\""

      [theme.templates.user.umbriel_gtk3_extras]
      input_path  = "$XDG_CACHE_HOME/noctalia/umbriel-gtk/gtk3-extras-input.css"
      output_path = "$XDG_CONFIG_HOME/gtk-3.0/colors-extras.css"
      index       = 1
      pre_hook    = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk/gtk3-input.sh\" > /dev/null"
      post_hook   = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk/gtk3-apply.sh\""

      [theme.templates.user.umbriel_firefox_buttons]
      input_path  = "$XDG_CACHE_HOME/noctalia/umbriel-gtk/firefox-buttons-input.css"
      output_path = "$XDG_CACHE_HOME/noctalia/umbriel-gtk/firefox-buttons.css"
      pre_hook    = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk/firefox-input.sh\" > /dev/null"
      post_hook   = "bash \"$HOME/.config/noctalia/templates/umbriel-gtk/firefox-apply.sh\""
    '';

    # papirus 和 umbriel-gtk 的模板输入用本模块目录下的文件。这些文件含大量
    # ${...} 和会被 Nix 多行字符串缩进破坏的内容，统一用 .source 部署。
    xdg.configFile = {
      "noctalia/templates/papirus/colors" = {
        source = ./papirus/colors;
        force = true;
      };
      "noctalia/templates/papirus/apply.sh" = {
        source = ./papirus/apply.sh;
        force = true;
      };

      "noctalia/templates/umbriel-gtk/gtk3-input.sh" = { source = ./umbriel-gtk/gtk3-input.sh; force = true; };
      "noctalia/templates/umbriel-gtk/gtk3-apply.sh" = { source = ./umbriel-gtk/gtk3-apply.sh; force = true; };
      "noctalia/templates/umbriel-gtk/gtk3-buttons.css" = { source = ./umbriel-gtk/gtk3-buttons.css; force = true; };
      "noctalia/templates/umbriel-gtk/gtk3-extras.css" = { source = ./umbriel-gtk/gtk3-extras.css; force = true; };
      "noctalia/templates/umbriel-gtk/gtk4-input.sh" = { source = ./umbriel-gtk/gtk4-input.sh; force = true; };
      "noctalia/templates/umbriel-gtk/gtk4-apply.sh" = { source = ./umbriel-gtk/gtk4-apply.sh; force = true; };
      "noctalia/templates/umbriel-gtk/gtk4-buttons.css" = { source = ./umbriel-gtk/gtk4-buttons.css; force = true; };
      "noctalia/templates/umbriel-gtk/gtk4-extras.css" = { source = ./umbriel-gtk/gtk4-extras.css; force = true; };
      "noctalia/templates/umbriel-gtk/firefox-input.sh" = { source = ./umbriel-gtk/firefox-input.sh; force = true; };
      "noctalia/templates/umbriel-gtk/firefox-apply.sh" = { source = ./umbriel-gtk/firefox-apply.sh; force = true; };
      "noctalia/templates/umbriel-gtk/firefox-buttons.css" = { source = ./umbriel-gtk/firefox-buttons.css; force = true; };

      # Darkly（qtengine 的 Qt 风格引擎）的圆角跟随 umbriel 的实际配置：
      # Legion 在 host 层把 corner_radius 覆盖成 1，Mech 用共享的 13。
      "darklyrc" = {
        text = ''
          [Common]
          ButtonHeight=1
          CornerRadius=${toString (lib.attrByPath [ "programs" "umbriel" "settings" "appearance" "corner_radius" ] 13 config)}

          [Style]
          NoOutline=true
          OpaqueInactiveWindows=true
          RoundedRubberBandFrame=false
        '';
        force = true;
      };
    };

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
      "themes/${config.gtk.theme.name}".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
    };
  };
}
