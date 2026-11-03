{
  appearance = {
    blur = {
      brightness = 0.9;
      contrast = 0.9;
      enabled = true;
      noise = 0.01;
      optimized = true;
      passes = 3;
      radius = 6;
      saturation = 1.1;
    };
    border_width = 1;
    corner_radius = 13;
    drag_opacity = 1;
    opaque_fullscreen = true;
    outer_border_width = 0;
    prefer_no_csd = true;
    shadow = {
      enabled = true;
      offset_x = 2;
      offset_y = 2;
      softness = 10;
    };
    tab_bar = {
      corner_radius = -1;
      font = "sans 10";
      height = 6;
      hide_when_single = true;
      max_tabs = 0;
      overflow = "scroll";
      padding = 8;
      position = "left";
      style = "titles";
      tab_gap = 2;
      title_align = "center";
      title_format = "{}";
      visible = true;
    };
    title_bar = {
      button_background = true;
      button_corner_radius = -1;
      button_glyph = "never";
      button_position = "left";
      buttons = [
        "minimize"
        "maximize"
        "close"
      ];
      font = "苹方-简 中黑体 10";
      height = 28;
      mode = "negotiated";
    };
  };
  colors = {
    border = {
      focused = "#44464fff";
      unfocused = "#1a1b2099";
    };
    overview = {
      background_tint = "#10101400";
      workspace_background = "#00000000";
    };
  };
}
