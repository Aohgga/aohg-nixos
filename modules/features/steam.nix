{
  flake.modules.nixos.steam = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      protonplus
    ];
    programs.steam = {
      enable = true;
      gamescopeSession.enable = false;
      protontricks.enable = true;
    };
  };
}
