{ ... }:
{
  flake.modules.homeManager.MechUmbriel = {
    programs.umbriel.settings =
      (import ../../../config/umbriel) {
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
  };
}
