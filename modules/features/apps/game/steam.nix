{ inputs, ... }:
{
  flake-file.inputs.millennium = {
    url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.steam = { pkgs, ... }: {
    nixpkgs.overlays = [ inputs.millennium.overlays.default ];

    environment.systemPackages = with pkgs; [
      protonplus
    ];
    programs.steam = {
      enable = true;
      gamescopeSession.enable = false;
      # Millennium 通过 LD_PRELOAD 注入，不改 Steam 文件，更新不会被还原
      package = pkgs.millennium-steam;
      protontricks.enable = true;
    };

    local.persistence.home.directories = [
      ".local/share/Steam"
      ".steam"
    ];
  };
}
