{
  environment = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    SDL_VIDEODRIVER = "wayland";
  };
  events = { };
  general = {
    attach_modal_dialogs = false;
    autostart = [
      "echo 'Xft.dpi:154' | xrdb -merge"
    ];
    focus_on_activate = false;
    honor_restored_maximize = false;
    mod_key = "Super";
    nvidia_sync_workaround = true;
    show_cheatsheet = false;
    xwayland = true;
    xwayland_native_resolution = true;
    xwayland_primary_output = "eDP-1";
    xwayland_xsettings = true;
  };
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
