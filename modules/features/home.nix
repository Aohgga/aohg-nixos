{
  flake.modules.homeManager.home = { pkgs, ... }: {
    home.username = "aohg";
    home.homeDirectory = "/home/aohg";
    home.sessionVariables = {
      SYSTEMD_TINT_BACKGROUND = "0";
    };

    # 不再生成 ~/.manpath
    programs.man.generateCaches = false;

    xdg = {
      enable = true;
      portal = {
        enable = true;
        # 与系统 /run/current-system/sw/share/xdg-desktop-portal/portals 保持同一套实现，
        # 避免 HM 接管 NIX_XDG_DESKTOP_PORTAL_DIR 后丢掉 denial/wlr/keyring。
        extraPortals = with pkgs; [
          denial
          gnome-keyring
          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
          xdg-desktop-portal-umbriel
          xdg-desktop-portal-wlr
        ];
        config.umbriel = {
          default = [ "umbriel" "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        };
      };
      userDirs.enable = true;
    };
  };
}
