{
  flake.modules.nixos.input-method = { pkgs, ... }: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          (fcitx5-rime.override {
            rimeDataPkgs = [ rime-ice ];
          })
        ];
        waylandFrontend = true;
      };
    };
    services.libinput.enable = true;

    local.persistence.home.directories = [
      ".config/fcitx5"
      ".local/share/fcitx5"
    ];
  };

  flake.modules.homeManager.input-method = { lib, ... }: {
    xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
      patch:
        __include: rime_ice_suggestion:/
    '';

    # fcitx5-mellow 主题。模板输入文件放在本模块目录下，由文件末尾的 xdg.configFile 部署。
    # 注册项追加到 theme.nix 写的 noctalia 配置末尾，同 wl-kbptr/swayimg 的做法。
    xdg.configFile."noctalia/config.toml".text = lib.mkAfter ''
      [theme.templates.user.fcitx5_mellow_conf]
      input_path  = "~/.config/noctalia/templates/fcitx5-mellow/theme.conf"
      output_path = "$XDG_DATA_HOME/fcitx5/themes/noctalia-mellow/theme.conf"
      # apply.sh 要 sed 两个 SVG 的圆角，必须等它们渲染完；index 是全局升序，
      # 不设就是 0。hook_async 默认 true，这里改同步，确保 templates-apply 返回时已生效。
      index       = 3
      hook_async  = false
      post_hook   = "bash \"$HOME/.config/noctalia/templates/fcitx5-mellow/apply.sh\""

      [theme.templates.user.fcitx5_mellow_panel]
      input_path  = "~/.config/noctalia/templates/fcitx5-mellow/panel.svg"
      output_path = "$XDG_DATA_HOME/fcitx5/themes/noctalia-mellow/panel.svg"

      [theme.templates.user.fcitx5_mellow_highlight]
      input_path  = "~/.config/noctalia/templates/fcitx5-mellow/highlight.svg"
      output_path = "$XDG_DATA_HOME/fcitx5/themes/noctalia-mellow/highlight.svg"
    '';

    # theme.conf 是 KConfig 格式，段名前的空格会让 fcitx5 解析失败，所以这几个文件
    # 用 .source 部署，不内联到 Nix 多行字符串里。
    xdg.configFile."noctalia/templates/fcitx5-mellow/theme.conf" = {
      source = ./fcitx5-mellow/theme.conf;
      force = true;
    };
    xdg.configFile."noctalia/templates/fcitx5-mellow/panel.svg" = {
      source = ./fcitx5-mellow/panel.svg;
      force = true;
    };
    xdg.configFile."noctalia/templates/fcitx5-mellow/highlight.svg" = {
      source = ./fcitx5-mellow/highlight.svg;
      force = true;
    };
    xdg.configFile."noctalia/templates/fcitx5-mellow/apply.sh" = {
      source = ./fcitx5-mellow/apply.sh;
      force = true;
    };
  };
}
