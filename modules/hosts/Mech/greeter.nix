{
  flake.modules.nixos.MechGreeter =
    { pkgs, ... }:
    {
      services.displayManager.noctalia-greeter = {
        cursorTheme = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
        };
        settings = {
          cursor.size = 20;
          output.refresh_rate = "DP-1:120; eDP-1:165";
        };
      };
    };
}
