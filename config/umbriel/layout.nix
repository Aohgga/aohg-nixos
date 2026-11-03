{
  layout = {
    client_maximize = "edges";
    dwindle = {
      new_toward_cursor = false;
      preserve_split = false;
    };
    extent_presets = [
      0.333
      0.5
      0.667
    ];
    gap = 5;
    master = {
      default_width_fraction = 0.55;
      new_becomes_master = false;
      new_on_top = true;
      position = "left";
    };
    mode = "stacking";
    new_exits_fullscreen = "all";
    scrolling = {
      center_focused = "on_overflow";
      center_on_overview_select = false;
      center_underfull_strip = true;
      default_extent_fraction = 0.5;
    };
    stacking = {
      drop_zones = true;
    };
    struts = {
      bottom = 0;
      left = 0;
      right = 0;
      top = 0;
    };
    tabs = {
      default_display = "tabbed";
      middle_click_closes = false;
      new_tab_position = "end";
      scroll_switches_tabs = true;
      wrap_focus = true;
    };
  };
}
