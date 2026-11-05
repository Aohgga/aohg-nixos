{
  flake.modules.homeManager.home = { lib, pkgs, ... }: {
    home.username = "aohg";
    home.homeDirectory = "/home/aohg";
    home.sessionVariables = {
      NIX_XDG_DESKTOP_PORTAL_DIR = lib.mkForce "/run/current-system/sw/share/xdg-desktop-portal/portals";
      SYSTEMD_TINT_BACKGROUND = "0";
    };

    # 不再生成 ~/.manpath
    programs.man.generateCaches = false;

    # portal 实现由 NixOS 统一安装；这里只让 home-manager 生成 config 文件，
    # 并把 portal 目录指回系统，避免用户 profile 接管后缺少实现。
    systemd.user.sessionVariables.NIX_XDG_DESKTOP_PORTAL_DIR =
      lib.mkForce "/run/current-system/sw/share/xdg-desktop-portal/portals";

    xdg = {
      enable = true;
      portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.umbriel = {
          default = [ "umbriel" "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        };
      };
      userDirs.enable = true;
    };
  };
}
