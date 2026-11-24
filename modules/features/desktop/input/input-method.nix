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

    # fcitx5-mellow 主题，模板输入文件是手写的（~/.config/noctalia/templates/fcitx5-mellow/）。
    # 注册项追加到 theme.nix 写的 noctalia 配置末尾，同 wl-kbptr/swayimg 的做法。
    xdg.configFile."noctalia/config.toml".text = lib.mkAfter ''
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
  };
}
