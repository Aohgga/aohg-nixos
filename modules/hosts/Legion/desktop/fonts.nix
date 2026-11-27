{ lib, ... }:
{
  flake.modules.nixos.LegionFonts =
    { pkgs, ... }:
    {
      fonts = {
        fontconfig = {
          antialias = true;
          confPackages = [
            (pkgs.writeTextDir "etc/fonts/conf.d/99-legion-bitmap.conf" ''
              <?xml version="1.0"?>
              <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
              <fontconfig>
                <!-- 点阵字体保持 1:1 无抗锯齿；其余字体用全局抗锯齿 -->
                <match target="font">
                  <test name="family" compare="contains">
                    <string>WenQuanYi Bitmap Song</string>
                  </test>
                  <edit name="antialias" mode="assign">
                    <bool>false</bool>
                  </edit>
                  <edit name="hinting" mode="assign">
                    <bool>true</bool>
                  </edit>
                  <edit name="embeddedbitmap" mode="assign">
                    <bool>true</bool>
                  </edit>
                </match>
                <match target="font">
                  <test name="family" qual="any">
                    <string>UnifontExMono</string>
                  </test>
                  <edit name="antialias" mode="assign">
                    <bool>false</bool>
                  </edit>
                  <edit name="hinting" mode="assign">
                    <bool>true</bool>
                  </edit>
                </match>
                <match target="font">
                  <test name="family" qual="any">
                    <string>Unifont</string>
                  </test>
                  <edit name="antialias" mode="assign">
                    <bool>false</bool>
                  </edit>
                  <edit name="hinting" mode="assign">
                    <bool>true</bool>
                  </edit>
                </match>
                <!-- Chromium/CEF 的 Skia 拒绝 bitmap-only 字体 -->
                <match target="pattern">
                  <test name="prgname" qual="any">
                    <string>helium</string>
                  </test>
                  <edit name="family" mode="assign_replace" binding="strong">
                    <string>Noto Sans CJK SC</string>
                  </edit>
                </match>
                <match target="pattern">
                  <test name="prgname" qual="any">
                    <string>steamwebhelper</string>
                  </test>
                  <edit name="family" mode="assign_replace" binding="strong">
                    <string>Noto Sans CJK SC</string>
                  </edit>
                </match>
                <!-- 非点阵字体只做后备：点阵压到族列表首位，中英文都先用它 -->
                <match target="pattern">
                  <test name="family" qual="any">
                    <string>sans</string>
                  </test>
                  <edit name="family" mode="prepend_first" binding="strong">
                    <string>WenQuanYi WenQuanYi Bitmap Song</string>
                  </edit>
                </match>
                <!-- 大于 22.5pt（96 DPI 下的 30px）才换轮廓：拉丁用 Inter，中文用苹方 -->
                <match target="pattern">
                  <test name="family" compare="contains">
                    <string>WenQuanYi WenQuanYi</string>
                  </test>
                  <test name="size" compare="more">
                    <double>22.5</double>
                  </test>
                  <edit name="family" mode="assign_replace" binding="strong">
                    <string>Inter</string>
                  </edit>
                  <edit name="family" mode="append_last" binding="strong">
                    <string>PingFang SC</string>
                  </edit>
                </match>
                <!-- 12pt 仍吸附到 16px 点阵，避免在非 96 DPI 下缩放位图 -->
                <match target="pattern">
                  <test name="family" compare="eq">
                    <string>WenQuanYi WenQuanYi Bitmap Song</string>
                  </test>
                  <test name="size" compare="more_eq">
                    <double>12</double>
                  </test>
                  <edit name="size" mode="assign">
                    <double>12</double>
                  </edit>
                  <edit name="pixelsize" mode="assign">
                    <double>16</double>
                  </edit>
                </match>
                <!-- 16–30px 之间不放大位图，直接钉在 16px 点阵上 -->
                <match target="pattern">
                  <test name="family" compare="contains">
                    <string>WenQuanYi WenQuanYi</string>
                  </test>
                  <test name="pixelsize" compare="more">
                    <double>16</double>
                  </test>
                  <test name="pixelsize" compare="less_eq">
                    <double>30</double>
                  </test>
                  <edit name="size" mode="assign">
                    <double>12</double>
                  </edit>
                  <edit name="pixelsize" mode="assign">
                    <double>16</double>
                  </edit>
                </match>
                <!-- 按像素请求时同样处理：超过 30px 走 Inter + 苹方 -->
                <match target="pattern">
                  <test name="family" compare="contains">
                    <string>WenQuanYi WenQuanYi</string>
                  </test>
                  <test name="pixelsize" compare="more">
                    <double>30</double>
                  </test>
                  <edit name="family" mode="assign_replace" binding="strong">
                    <string>Inter</string>
                  </edit>
                  <edit name="family" mode="append_last" binding="strong">
                    <string>PingFang SC</string>
                  </edit>
                </match>
                <!-- libass（mpv/uosc/ModernZ）在 Inter 缺中文时回退到苹方；不能回退到
                     点阵 OTB 版宋体，libass 渲染不了纯点阵字体，中文会变成豆腐块。这条
                     放在最后，避免被上面的 Noto 降级规则改掉族列表。 -->
                <match target="pattern">
                  <test name="family" qual="any">
                    <string>Inter</string>
                  </test>
                  <edit name="family" mode="append" binding="weak">
                    <string>PingFang SC</string>
                  </edit>
                </match>
              </fontconfig>
            '')
          ];
          defaultFonts = lib.mkForce {
            emoji = [ "Noto Color Emoji" ];
            monospace = [
              "Terminess Nerd Font"
              "WenQuanYi Bitmap Song 12pt Mono"
              "UnifontExMono"
              "SimSun"
            ];
            sansSerif = [
              "WenQuanYi WenQuanYi Bitmap Song"
              "Inter"
              "PingFang SC"
              "Noto Sans CJK SC"
            ];
            serif = [
              "WenQuanYi WenQuanYi Bitmap Song"
              "PingFang SC"
              "Noto Serif CJK SC"
            ];
          };
          hinting = {
            enable = lib.mkForce true;
            style = "full";
          };
          subpixel.rgba = lib.mkForce "none";
        };
      };

      # Qt 走 qtengine，字体在它的 config 里单独指定。
      # 全局用的是 苹方-简 / Maple Mono，Legion 上改成和 GTK、kitty 一致的点阵宋体
      # 与 Terminess（Qt 的 UI 字体 + 等宽字体）。
      programs.qtengine.config.theme = {
        font = lib.mkForce {
          family = "WenQuanYi WenQuanYi Bitmap Song";
          size = 12;
          weight = -1;
        };
        fontFixed = lib.mkForce {
          family = "Terminess Nerd Font";
          size = 12;
          weight = -1;
        };
      };
    };

  flake.modules.homeManager.LegionFonts =
    { lib, pkgs, ... }:
    {
      gtk.font = lib.mkForce {
        name = "WenQuanYi WenQuanYi Bitmap Song";
        size = 12;
      };
      programs.kitty.font = lib.mkForce {
        name = "Terminess Nerd Font";
        package = pkgs.nerd-fonts.terminess-ttf;
        size = 12;
      };
    };
}
