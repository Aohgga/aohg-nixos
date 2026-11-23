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
      config.common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "luciole" "gtk" ];
      };
    };

    local.persistence.home.directories = [
      ".config/luciole"
      ".local/share/luciole"
      ".local/state/luciole"
    ];
  };
}
