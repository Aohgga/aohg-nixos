{ inputs, ... }:
{
  flake.modules.nixos.umbriel = { pkgs, ... }: {
    imports = [
      inputs.noctalia.nixosModules.default
      inputs.umbriel.nixosModules.default
    ];
    services.gvfs.enable = true;
    programs.dconf.enable = true;
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };
    programs.umbriel = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-umbriel;
    };
    xdg.portal.extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

  flake.modules.homeManager.umbriel = {
    imports = [ inputs.umbriel.homeModules.default ];
    programs.umbriel.enable = true;

    # portal 配置是 umbriel 专属。手写文件而不是用 xdg.portal.config：
    # 后者会为生成同一个文件把整个 portal 栈装进用户 profile，并改写
    # NIX_XDG_DESKTOP_PORTAL_DIR，收益为零。
    xdg.configFile."xdg-desktop-portal/umbriel-portals.conf".text = ''
      [preferred]
      default = umbriel;gtk
      org.freedesktop.impl.portal.FileChooser = kde
    '';
  };
}
