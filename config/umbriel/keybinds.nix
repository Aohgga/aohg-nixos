{
  keybinds = {
    "Alt+Tab" = {
      action = "spawn noctalia msg window-switcher";
      repeat = false;
    };
    "Mod+1" = "workspace-switch 1";
    "Mod+2" = "workspace-switch 2";
    "Mod+3" = "workspace-switch 3";
    "Mod+4" = "workspace-switch 4";
    "Mod+5" = "workspace-switch 5";
    "Mod+6" = "workspace-switch 6";
    "Mod+7" = "workspace-switch 7";
    "Mod+8" = "workspace-switch 8";
    "Mod+9" = "workspace-switch 9";
    "Mod+A" = "window-toggle-maximize";
    "Mod+Alt+Equal" = "window-modify-secondary-extent 0.1";
    "Mod+Alt+Minus" = "window-modify-secondary-extent -0.1";
    "Mod+Alt+R" = "window-cycle-secondary-extent";
    "Mod+Alt+Shift+R" = "window-cycle-secondary-extent-back";
    "Mod+B" = {
      action = "spawn pgrep bluetui && pkill bluetui || app2unit kitty -e --app-id float_term bluetui";
      repeat = false;
    };
    "Mod+Bracketleft" = "window-focus-previous";
    "Mod+Bracketright" = "window-focus-next";
    "Mod+C" = "column-center";
    "Mod+Comma" = "output-focus-left";
    "Mod+Ctrl+1" = "window-move-to-workspace-silent 1";
    "Mod+Ctrl+2" = "window-move-to-workspace-silent 2";
    "Mod+Ctrl+3" = "window-move-to-workspace-silent 3";
    "Mod+Ctrl+4" = "window-move-to-workspace-silent 4";
    "Mod+Ctrl+5" = "window-move-to-workspace-silent 5";
    "Mod+Ctrl+6" = "window-move-to-workspace-silent 6";
    "Mod+Ctrl+7" = "window-move-to-workspace-silent 7";
    "Mod+Ctrl+8" = "window-move-to-workspace-silent 8";
    "Mod+Ctrl+9" = "window-move-to-workspace-silent 9";
    "Mod+Ctrl+F" = "window-toggle-maximize";
    "Mod+Ctrl+H" = "window-consume-or-expel-left";
    "Mod+Ctrl+J" = "column-focus-tab-next";
    "Mod+Ctrl+K" = "column-focus-tab-previous";
    "Mod+Ctrl+L" = "window-consume-or-expel-right";
    "Mod+Ctrl+O" = "window-move-to-workspace-silent-next";
    "Mod+Ctrl+S" = "window-restore-from-scratchpad";
    "Mod+Ctrl+T" = "workspace-set-layout toggle";
    "Mod+Ctrl+U" = "window-move-to-workspace-silent-previous";
    "Mod+D" = {
      action = "spawn noctalia msg panel-toggle launcher";
      repeat = false;
    };
    "Mod+Down" = "window-focus-down";
    "Mod+E" = {
      action = "spawn kitty -e yazi";
      repeat = false;
    };
    "Mod+End" = "column-focus-last";
    "Mod+Equal" = "window-modify-primary-extent 0.1";
    "Mod+Escape" = {
      action = "spawn noctalia msg panel-toggle session";
      repeat = false;
    };
    "Mod+F" = "window-toggle-maximize-to-edges";
    "Mod+Grave" = {
      action = "overview-toggle";
      repeat = false;
    };
    "Mod+H" = "window-focus-left";
    "Mod+Home" = "column-focus-first";
    "Mod+J" = "window-focus-down";
    "Mod+K" = "window-focus-up";
    "Mod+L" = "window-focus-right";
    "Mod+Left" = "window-focus-left";
    "Mod+M" = {
      action = "spawn pgrep musicfox && pkill musicfox || app2unit kitty -e --app-id float_term musicfox";
      repeat = false;
    };
    "Mod+Minus" = "window-modify-primary-extent -0.1";
    "Mod+MouseMiddle" = "layout-scroll-drag";
    "Mod+G" = {
      action = "spawn noctalia msg panel-toggle alexander/game-launcher:browser";
      repeat = false;
    };
    "Mod+N" = {
      action = "spawn noctalia msg panel-toggle noctalia/notes:panel";
      repeat = false;
    };
    "Mod+O" = "workspace-next";
    "Mod+P" = {
      action = "spawn pgrep wiremix && pkill wiremix || app2unit kitty --app-id float_term -e wiremix";
      repeat = false;
    };
    "Mod+Page_Down" = "workspace-next";
    "Mod+Page_Up" = "workspace-previous";
    "Mod+Period" = "output-focus-right";
    "Mod+Print" = {
      action = "spawn noctalia msg screenshot-region";
      repeat = false;
    };
    "Mod+Q" = "window-close";
    "Mod+R" = "window-cycle-primary-extent";
    "Mod+Return" = {
      action = "spawn app2unit kitty";
      repeat = false;
    };
    "Mod+Right" = "window-focus-right";
    "Mod+S" = "scratchpad-toggle";
    "Mod+Semicolon" = {
      action = "spawn noctalia msg panel-toggle launcher /emo";
      repeat = false;
    };
    "Mod+Shift+1" = "window-move-to-workspace 1";
    "Mod+Shift+2" = "window-move-to-workspace 2";
    "Mod+Shift+3" = "window-move-to-workspace 3";
    "Mod+Shift+4" = "window-move-to-workspace 4";
    "Mod+Shift+5" = "window-move-to-workspace 5";
    "Mod+Shift+6" = "window-move-to-workspace 6";
    "Mod+Shift+7" = "window-move-to-workspace 7";
    "Mod+Shift+8" = "window-move-to-workspace 8";
    "Mod+Shift+9" = "window-move-to-workspace 9";
    "Mod+Shift+Bracketleft" = "window-swap-previous";
    "Mod+Shift+Bracketright" = "window-swap-next";
    "Mod+Shift+C" = "window-center";
    "Mod+Shift+Comma" = "column-move-to-output-left";
    "Mod+Shift+Down" = "window-move-down";
    "Mod+Shift+E" = {
      action = "spawn strata";
      repeat = false;
    };
    "Mod+Shift+End" = "column-move-to-last";
    "Mod+Shift+F" = "window-toggle-fullscreen";
    "Mod+Shift+H" = "column-move-left";
    "Mod+Shift+Home" = "column-move-to-first";
    "Mod+Shift+J" = "window-move-down";
    "Mod+Shift+K" = "window-move-up";
    "Mod+Shift+L" = "column-move-right";
    "Mod+Shift+Left" = "column-move-left";
    "Mod+Shift+N" = {
      action = "spawn noctalia msg settings-toggle";
      repeat = false;
    };
    "Mod+Shift+O" = "window-move-to-workspace-next";
    "Mod+Shift+P" = "window-toggle-pinned";
    "Mod+Shift+Page_Down" = "window-move-to-workspace-next";
    "Mod+Shift+Page_Up" = "window-move-to-workspace-previous";
    "Mod+Shift+Period" = "column-move-to-output-right";
    "Mod+Shift+Print" = {
      action = "spawn noctalia msg screenshot-fullscreen";
      repeat = false;
    };
    "Mod+Shift+R" = "window-cycle-primary-extent-back";
    "Mod+Shift+Return" = {
      action = "spawn app2unit kitty --app-id float_term";
      repeat = false;
    };
    "Mod+Shift+Right" = "column-move-right";
    "Mod+Shift+S" = "window-move-to-scratchpad";
    "Mod+Shift+Space" = "window-focus-switch-floating";
    "Mod+Shift+U" = "window-move-to-workspace-previous";
    "Mod+Shift+Up" = "window-move-up";
    "Mod+Shift+W" = {
      action = "spawn noctalia msg panel-toggle noctalia/wallhaven:browser";
      repeat = false;
    };
    "Mod+Slash" = "cheatsheet-toggle";
    "Mod+Space" = "window-toggle-floating";
    "Mod+Tab" = "scratchpad-focus-next";
    "Mod+U" = "workspace-previous";
    "Mod+Up" = "window-focus-up";
    "Mod+V" = {
      action = "spawn noctalia msg panel-toggle clipboard";
      repeat = false;
    };
    "Mod+W" = {
      action = "spawn noctalia msg panel-toggle wallpaper";
      repeat = false;
    };
    "Mod+WheelDown" = {
      action = "workspace-next";
      cooldown_ms = 150;
    };
    "Mod+WheelUp" = {
      action = "workspace-previous";
      cooldown_ms = 150;
    };
    "Mod+X" = {
      action = "spawn noctalia msg bar-toggle";
      repeat = false;
    };
    "Shift+XF86AudioLowerVolume" = {
      action = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
      allow_when_locked = true;
    };
    "Shift+XF86AudioRaiseVolume" = {
      action = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
      allow_when_locked = true;
    };
    XF86AudioLowerVolume = {
      action = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      allow_when_locked = true;
    };
    XF86AudioMute = {
      action = "spawn wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      allow_when_locked = true;
    };
    XF86AudioNext = {
      action = "spawn playerctl next";
      allow_when_locked = true;
    };
    XF86AudioPlay = {
      action = "spawn playerctl play-pause";
      allow_when_locked = true;
    };
    XF86AudioPrev = {
      action = "spawn playerctl previous";
      allow_when_locked = true;
    };
    XF86AudioRaiseVolume = {
      action = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      allow_when_locked = true;
    };
    XF86MonBrightnessDown = {
      action = "spawn noctalia msg brightness-down 10";
      allow_when_locked = true;
    };
    XF86MonBrightnessUp = {
      action = "spawn noctalia msg brightness-up 10";
      allow_when_locked = true;
    };

    # 小键盘当鼠标：用 ydotool 注入指针事件（仅 NumLock 开启时的 keysym）。
    # 1/2/3/4/6/7/8/9 八个方向（横竖 10px，斜向 7px），
    # 按住 Shift 速度翻倍（横竖 20px，斜向 14px）。
    # 5 左键、0 右键，-/+ 滚轮，Shift+-/+ 左右滚动。
    # 注意：umbriel 的 Shift 修饰键不分左右，Shift_L / Shift_R 都算 Shift。
    KP_7 = "spawn ydotool mousemove -x -7 -y -7";
    KP_8 = "spawn ydotool mousemove -x 0 -y -10";
    KP_9 = "spawn ydotool mousemove -x 7 -y -7";
    KP_4 = "spawn ydotool mousemove -x -10 -y 0";
    KP_6 = "spawn ydotool mousemove -x 10 -y 0";
    KP_1 = "spawn ydotool mousemove -x -7 -y 7";
    KP_2 = "spawn ydotool mousemove -x 0 -y 10";
    KP_3 = "spawn ydotool mousemove -x 7 -y 7";
    "Shift+KP_7" = "spawn ydotool mousemove -x -14 -y -14";
    "Shift+KP_8" = "spawn ydotool mousemove -x 0 -y -20";
    "Shift+KP_9" = "spawn ydotool mousemove -x 14 -y -14";
    "Shift+KP_4" = "spawn ydotool mousemove -x -20 -y 0";
    "Shift+KP_6" = "spawn ydotool mousemove -x 20 -y 0";
    "Shift+KP_1" = "spawn ydotool mousemove -x -14 -y 14";
    "Shift+KP_2" = "spawn ydotool mousemove -x 0 -y 20";
    "Shift+KP_3" = "spawn ydotool mousemove -x 14 -y 14";
    KP_5 = {
      action = "spawn ydotool click 0xC0";
      repeat = false;
    };
    KP_0 = {
      action = "spawn ydotool click 0xC1";
      repeat = false;
    };
    # 滚轮：+ 向下、- 向上
    KP_Add = "spawn ydotool mousemove -w -x 0 -y -1";
    KP_Subtract = "spawn ydotool mousemove -w -x 0 -y 1";
    "Shift+KP_Add" = "spawn ydotool mousemove -w -x 1 -y 0";
    "Shift+KP_Subtract" = "spawn ydotool mousemove -w -x -1 -y 0";
  };
}
