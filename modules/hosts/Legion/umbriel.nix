{ ... }:
{
  flake.modules.homeManager.LegionUmbriel = {
    programs.umbriel.settings =
      (import ../../../config/umbriel) {
        "eDP-1" = {
          focus_at_startup = true;
          mode = "1920x1080@60.164";
          position = [ 0 0 ];
          scale = 1.3333333;
          transform = "normal";
          workspaces = "dynamic";
          min_workspaces = 1;
          workspace_axis = "vertical";
        };

        "DP-1" = {
          mode = "3840x2160@59.997";
          position = [ 1536 0 ];
          scale = 1.6;
          transform = "normal";
          tearing = true;
          direct_scanout = true;
          workspaces = "dynamic";
          min_workspaces = 1;
          workspace_axis = "vertical";
        };
      };
  };
}
