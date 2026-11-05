{
  flake.modules.homeManager.home = {
    home.homeDirectory = "/home/aohg";
    home.sessionVariables = {
      SYSTEMD_TINT_BACKGROUND = "0";
    };
    home.username = "aohg";

    # 不再生成 ~/.manpath
    programs.man.generateCaches = false;

    # xdg-desktop-portal 的用户级配置（从 ~/.config 迁入 Nix）
    xdg.configFile = {
      "xdg-desktop-portal/hyprland-portals.conf".text = ''
        [preferred]
        default = hyprland;gtk
        org.freedesktop.impl.portal.FileChooser = kde
      '';
      "xdg-desktop-portal/umbriel-portals.conf".text = ''
        [preferred]
        default = umbriel;gtk
        org.freedesktop.impl.portal.FileChooser = kde
      '';
    };
    xdg.enable = true;
    xdg.userDirs.enable = true;
  };
}
