{ lib, ... }:
{
  flake.modules.nixos.LegionFonts =
    { pkgs, ... }:
    {
      fonts = {
        packages = [ pkgs.inter ];
        fontconfig = {
          antialias = true;
          confPackages = [
            (pkgs.writeTextDir "etc/fonts/conf.d/99-legion-bitmap.conf" ''
              <?xml version="1.0"?>
              <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
              <fontconfig>
                <!-- 点阵字体保持 1:1 无抗锯齿；其余字体用全局抗锯齿 -->
                <match target="font">
                  <test name="family" qual="any">
                    <string>WenQuanYi WenQuanYi Bitmap Song</string>
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
                <!-- 点阵只有 16px 一档，更大的字号会被放大成模糊点阵 -->
                <match target="pattern">
                  <test name="family" qual="any">
                    <string>WenQuanYi WenQuanYi Bitmap Song</string>
                  </test>
                  <test name="pixelsize" compare="more">
                    <double>19.5</double>
                  </test>
                  <edit name="family" mode="assign_replace" binding="strong">
                    <string>Noto Sans CJK SC</string>
                  </edit>
                </match>
                <match target="pattern">
                  <test name="family" qual="any">
                    <string>WenQuanYi WenQuanYi Bitmap Song</string>
                  </test>
                  <test name="size" compare="more">
                    <double>14.6</double>
                  </test>
                  <edit name="family" mode="assign_replace" binding="strong">
                    <string>Noto Sans CJK SC</string>
                  </edit>
                </match>
              </fontconfig>
            '')
          ];
          defaultFonts = lib.mkForce {
            emoji = [ "Noto Color Emoji" ];
            monospace = [ "Maple Mono NL NF CN" ];
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
      programs.kitty.settings.symbol_map = "U+3000-U+9FFF,U+F900-U+FAFF,U+FF00-U+FFEF UnifontExMono";
    };
}
