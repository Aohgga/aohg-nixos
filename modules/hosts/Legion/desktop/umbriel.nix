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

      # umbriel 的 keybind 是「修饰键精确匹配」的：按住 Shift/Ctrl 时 KP_8 不会
      # 命中裸 KP_8。游戏里这些键常和 Shift（潜行）/Ctrl（疾跑）一起按，所以给
      # 常用修饰键组合各生成一份绑定，让修饰键对小键盘鼠标完全透明。
      numpadMods = [
        ""
        "Shift+"
        "Ctrl+"
        "Alt+"
        "Shift+Ctrl+"
        "Shift+Alt+"
        "Ctrl+Alt+"
        "Shift+Ctrl+Alt+"
      ];

      numpadKeys = {
        # 方向键：按住启动 mouselook 注入（600 px/s、每次 1px，斜向自动归一化）
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
        # 5 左键、0 右键、/ 中键：按住按下、松开释放
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
        KP_Divide = {
          action = "spawn ydotool click 0x42";
          release = "spawn ydotool click 0x82";
          repeat = false;
        };
        # 按住 +：视角速度降到 1/10（600 → 60）
        KP_Add = {
          action = "spawn mouselook scale 0.1";
          release = "spawn mouselook scale 1";
          repeat = false;
        };
        # 滚轮：- 向下、* 向上
        KP_Subtract = {
          action = "spawn ydotool mousemove -w -x 0 -y -1";
        };
        KP_Multiply = {
          action = "spawn ydotool mousemove -w -x 0 -y 1";
        };
      };

      numpadBinds = builtins.listToAttrs (
        lib.concatMap
          (prefix: lib.mapAttrsToList (key: value: {
            name = prefix + key;
            value = value;
          }) numpadKeys)
          numpadMods
      );
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

        } // numpadBinds;
      };
  };
}
