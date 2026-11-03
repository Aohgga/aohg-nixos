{
  flake.modules.homeManager.home = {
    home.username = "aohg";
    home.homeDirectory = "/home/aohg";
    xdg = {
      enable = true;
      userDirs.enable = true;
    };
    home.sessionVariables = {
      SYSTEMD_TINT_BACKGROUND = "0";
    };

    # 不再生成 ~/.manpath
    programs.man.generateCaches = false;

    # xdg-desktop-portal 的用户级配置（从 ~/.config 迁入 Nix）
    xdg.configFile = {
      "xdg-desktop-portal/umbriel-portals.conf".text = ''
        [preferred]
        default = umbriel;gtk
        org.freedesktop.impl.portal.FileChooser = kde
      '';
      "xdg-desktop-portal/hyprland-portals.conf".text = ''
        [preferred]
        default = hyprland;gtk
        org.freedesktop.impl.portal.FileChooser = kde
      '';
    };
  };
}
