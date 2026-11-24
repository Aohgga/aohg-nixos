{ inputs, ... }:
{
  flake-file.inputs.luciole = {
    url = "github:noctalia-dev/luciole/cachix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.luciole = { pkgs, ... }: {
    imports = [ inputs.luciole.nixosModules.default ];

    programs.luciole.enable = true;

    # Trash 和网络位置依赖会话内的 GVfs daemon 与 D-Bus 激活。
    services.gvfs.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [
        inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "luciole" ];
        };
        # umbriel 的模块另外写了一份桌面专属的 umbriel-portals.conf
        # （default=umbriel;gtk）。XDG_CURRENT_DESKTOP=Umbriel 时这份文件会整体
        # 取代 portals.conf（两者不合并），所以 FileChooser 也要在这里写一遍，
        # 否则会落到 xdg-desktop-portal 内置的 gtk 实现。
        umbriel."org.freedesktop.impl.portal.FileChooser" = [ "luciole" ];
      };
    };

    local.persistence.home.directories = [
      ".config/luciole"
      ".local/share/luciole"
      ".local/state/luciole"
    ];
  };
}
