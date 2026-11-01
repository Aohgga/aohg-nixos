{
  flake.modules.nixos.steam = { pkgs, ... }: {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };
    environment.systemPackages = with pkgs; [
      protonplus
    ];
  };
}
