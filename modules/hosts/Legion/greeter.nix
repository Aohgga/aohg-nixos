{
  flake.modules.nixos.LegionGreeter =
    { pkgs, ... }:
    {
      services.displayManager.noctalia-greeter = {
        cursorTheme = {
          package = pkgs.miku-cursors;
          name = "miku-cursor-linux";
        };
        settings = {
          cursor.size = 24;
          output.refresh_rate = "DP-1:60; eDP-1:60";
        };
      };
    };
}
