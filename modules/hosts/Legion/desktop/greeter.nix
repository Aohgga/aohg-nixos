{
  flake.modules.nixos.LegionGreeter =
    { pkgs, ... }:
    {
      services.displayManager.noctalia-greeter = {
        settings = {
          cursor = {
            theme = "miku-cursor-linux";
            size = 24;
            path = pkgs.miku-cursors;
          };
          output.refresh_rate = "DP-1:59.997; eDP-1:60.164";
        };
      };
    };
}
