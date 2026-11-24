{ lib, ... }:
{
  flake.modules.homeManager.LegionUmbriel = { pkgs, ... }:
    let
      # 常驻的小步长鼠标注入器：按住方向键时以 600 次/秒注入 1px 位移，
      # 比每步 fork 一个 ydotool 顺滑得多，空闲时 poll 阻塞不占 CPU。
      mouselook = pkgs.stdenv.mkDerivation {
        pname = "mouselook";
        version = "1";
        src = ./mouselook.c;
        dontUnpack = true;
        dontBuild = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          $CC -O2 -Wall $src -o $out/bin/mouselook
          runHook postInstall
        '';
        meta.mainProgram = "mouselook";
      };
    in
    {
      home.packages = [ mouselook ];

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
          # 1/2/3/4/6/7/8/9 八个方向：按住启动 mouselook 注入（600 px/s、每次 1px，
          # 斜向自动归一化速度），松开停止；按住 + 时倍率降到 0.1（60 px/s）。
          # 游戏里再开 Smooth Camera 更顺。
          # 5 左键、0 右键，/ 中键（滚轮键），-/* 滚轮，Shift+-/* 左右滚动。
          # 注意：umbriel 的 Shift 修饰键不分左右，Shift_L / Shift_R 都算 Shift。
          KP_7 = {
            action = "spawn mouselook start nw -1 -1 600";
            release = "spawn mouselook stop nw";
            repeat = false;
          };
          KP_8 = {
            action = "spawn mouselook start up 0 -1 600";
            release = "spawn mouselook stop up";
            repeat = false;
          };
          KP_9 = {
            action = "spawn mouselook start ne 1 -1 600";
            release = "spawn mouselook stop ne";
            repeat = false;
          };
          KP_4 = {
            action = "spawn mouselook start w -1 0 600";
            release = "spawn mouselook stop w";
            repeat = false;
          };
          KP_6 = {
            action = "spawn mouselook start e 1 0 600";
            release = "spawn mouselook stop e";
            repeat = false;
          };
          KP_1 = {
            action = "spawn mouselook start sw -1 1 600";
            release = "spawn mouselook stop sw";
            repeat = false;
          };
          KP_2 = {
            action = "spawn mouselook start s 0 1 600";
            release = "spawn mouselook stop s";
            repeat = false;
          };
          KP_3 = {
            action = "spawn mouselook start se 1 1 600";
            release = "spawn mouselook stop se";
            repeat = false;
          };
          # 5/0 改成按住语义：按下 = 鼠标键按下，松开 = 鼠标键松开（配合上面的
          # 方向键移动，可以按住 5 拖动选中文字）。0x40/0x80 是左键按下/松开，
          # 0x41/0x81 是右键按下/松开。
          KP_5 = {
            action = "spawn ydotool click 0x40";
            release = "spawn ydotool click 0x80";
            repeat = false;
          };
          KP_0 = {
            action = "spawn ydotool click 0x41";
            release = "spawn ydotool click 0x81";
            repeat = false;
          };
          # 滚轮：- 向下、* 向上（原来 + 向下、- 向上，整体上移一格）
          KP_Subtract = "spawn ydotool mousemove -w -x 0 -y -1";
          KP_Multiply = "spawn ydotool mousemove -w -x 0 -y 1";
          "Shift+KP_Subtract" = "spawn ydotool mousemove -w -x 1 -y 0";
          "Shift+KP_Multiply" = "spawn ydotool mousemove -w -x -1 -y 0";
          # / = 中键（滚轮键）按住/松开
          KP_Divide = {
            action = "spawn ydotool click 0x42";
            release = "spawn ydotool click 0x82";
            repeat = false;
          };
          # 按住 +：视角速度降到 1/10（600 → 60），便于精调；松开恢复正常
          KP_Add = {
            action = "spawn mouselook scale 0.1";
            release = "spawn mouselook scale 1";
            repeat = false;
          };
        };
      };
  };
}
