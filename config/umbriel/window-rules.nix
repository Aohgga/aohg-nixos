{
  window_rule = [
    {
      blur = true;
      blur_ignore_alpha = 0.5;
      blur_optimized = false;
      blur_popups = true;
    }
    {
      default_floating = true;
      default_floating_size_px = {
        height = 900;
        width = 1020;
      };
      match = {
        app_id = "^dev.noctalia.Noctalia$";
      };
    }
    {
      default_floating = true;
      default_floating_size_px = {
        height = 600;
        width = 800;
      };
      match = {
        app_id = "^dev.noctalia.UmbrielSharePicker$";
      };
    }
    {
      default_floating = true;
      default_maximize = false;
      default_position = {
        anchor = "bottom_right";
        x = 20;
        y = 20;
      };
      match = {
        title = "^(Picture-in-Picture|Picture in picture)$";
      };
    }
    {
      default_focused = false;
      default_pinned = true;
      default_position = {
        anchor = "bottom_right";
        x = 0;
        y = 0;
      };
      match = {
        title = "^notificationtoasts_.+_desktop";
      };
    }
    {
      default_floating = false;
      match = {
        app_id = "org.kde.dolphin";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "org.kde.isoimagewriter";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "org.freedesktop.impl.portal.desktop.kde";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "qemu-system-x86_64";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "VBoxSDL";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "float_term";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "mgba";
      };
    }
    {
      blur = true;
      match = {
        app_id = "vicinae";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "com.github.AppManager";
      };
    }
    {
      default_floating = false;
      match = {
        title = "AppManager";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "org.kde.kdialog";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "scrcpy";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "steam_app_*";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "steam_app_431960";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = ".exe";
      };
    }
    {
      default_floating = true;
      default_floating_size_px = {
        height = 600;
        width = 800;
      };
      match = {
        title = "媒体查看器";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "mpv";
      };
    }
    {
      corner_radius = 0;
      default_floating = false;
      match = {
        app_id = "com.github.iwalton3.jellyfin-mpv-shim";
      };
    }
    {
      default_floating = true;
      match = {
        app_id = "org.kde.dolphin";
        title = "的属性";
      };
    }
  ];
}
