{ ... }:
{
  flake.modules.homeManager.MechUmbriel =
    let
      settings = (import ../../../../config/umbriel) {
        "DP-1" = {
          focus_at_startup = true;
          mode = "3840x2160@119.88";
          position = [ 1600 0 ];
          scale = 1.6;
          transform = "normal";
          tearing = true;
          direct_scanout = true;
          workspaces = "dynamic";
          min_workspaces = 1;
          workspace_axis = "vertical";
        };

        "eDP-1" = {
          mode = "2560x1440@165.003";
          position = [ 0 0 ];
          scale = 1.6;
          transform = "normal";
          vrr = "always";
          tearing = true;
          direct_scanout = true;
          workspaces = "dynamic";
          min_workspaces = 1;
          workspace_axis = "vertical";
        };
      };
    in
    {
      # jellyfin-mpv-shim 只在 Mech 上安装，它的窗口规则也只在这里生效。
      programs.umbriel.settings = settings // {
        window_rule = settings.window_rule ++ [
          {
            corner_radius = 0;
            default_floating = false;
            match = {
              app_id = "com\\.github\\.iwalton3\\.jellyfin-mpv-shim";
            };
          }
        ];
      };
    };
}
