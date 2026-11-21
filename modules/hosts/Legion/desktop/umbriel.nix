{ lib, ... }:
{
  flake.modules.homeManager.LegionUmbriel = {
    programs.umbriel.settings = lib.recursiveUpdate
      ((import ../../../../config/umbriel) {
        "eDP-1" = {
          focus_at_startup = true;
          mode = "1920x1080@60.164";
          position = [ 0 0 ];
          scale = 1.0;
          transform = "normal";
          workspaces = "dynamic";
          min_workspaces = 1;
          workspace_axis = "vertical";
        };

        "DP-1" = {
          mode = "3840x2160@59.997";
          position = [ 1920 0 ];
          scale = 1.6;
          transform = "normal";
          tearing = true;
          direct_scanout = true;
          workspaces = "dynamic";
          min_workspaces = 1;
          workspace_axis = "vertical";
        };
      })
      {
        appearance = {
          corner_radius = 1;
          title_bar = {
            font = "WenQuanYi WenQuanYi Bitmap Song 12";
            height = 34;
          };
        };
        colors = {
          border = {
            focused = "#3a3a3aff";
            unfocused = "#3a3a3a80";
          };
        };
        general.autostart = [ ];
        input.cursor = {
          size = 24;
          theme = "miku-cursor-linux";
        };
        layout.mode = "scrolling";
        keybinds = {
          # 键盘控制指针：触控板难用时用
          "Mod+G" = {
            action = "spawn wl-kbptr";
            repeat = false;
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
      };
  };
}
