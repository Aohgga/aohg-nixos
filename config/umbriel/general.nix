{
  general = {
    autostart = [
      "echo 'Xft.dpi:154' | xrdb -merge"
    ];
    mod_key = "Super";
    xwayland = true;
    xwayland_native_resolution = true;
    xwayland_xsettings = true;
    xwayland_primary_output = "eDP-1";
    nvidia_sync_workaround = true;
    show_cheatsheet = false;
    focus_on_activate = false;
    attach_modal_dialogs = false;
    honor_restored_maximize = false;
  };
  environment = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    SDL_VIDEODRIVER = "wayland";
  };
  events = { };
  hot_corners = {
    bottom_left = {
      action = "overview-toggle";
      delay_ms = 500;
      enabled = false;
    };
    bottom_right = {
      action = "spawn notify-send 'Bottom right'";
      delay_ms = 500;
      enabled = false;
    };
    top_left = {
      action = "overview-open";
      delay_ms = 500;
      enabled = true;
    };
    top_right = {
      action = "overview-close";
      delay_ms = 500;
      enabled = false;
    };
  };
}
