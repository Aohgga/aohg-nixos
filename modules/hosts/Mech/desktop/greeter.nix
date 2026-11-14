{
  flake.modules.nixos.MechGreeter =
    { pkgs, ... }:
    {
      services.displayManager.noctalia-greeter = {
        settings = {
          cursor = {
            theme = "Bibata-Modern-Ice";
            size = 20;
            path = pkgs.bibata-cursors;
          };
          output.refresh_rate = "DP-1:119.880; eDP-1:165.003";
        };
      };
    };
}
