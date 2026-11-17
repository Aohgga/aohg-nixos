{ inputs, ... }:
{
  flake-file.inputs.luciole = {
    url = "github:noctalia-dev/luciole";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.luciole = {
    imports = [ inputs.luciole.nixosModules.default ];

    programs.luciole.enable = true;

    # Trash 和网络位置依赖会话内的 GVfs daemon 与 D-Bus 激活。
    services.gvfs.enable = true;

    local.persistence.home.directories = [
      ".config/luciole"
      ".local/share/luciole"
      ".local/state/luciole"
    ];
  };
}
