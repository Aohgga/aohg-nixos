{ lib, ... }:
{
  flake.modules.nixos.LegionFonts =
    { pkgs, ... }:
    {
      fonts.fontconfig = {
        antialias = false;
        confPackages = [
          (pkgs.writeTextDir "etc/fonts/conf.d/99-legion-bitmap.conf" ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
            <fontconfig>
              <!-- Chromium/CEF 的 Skia 拒绝 bitmap-only 字体。这些进程只能看
                   矢量字体，否则会渲染成缺字。 -->
              <match target="pattern">
                <test name="prgname" qual="any">
                  <string>helium</string>
                </test>
                <edit name="family" mode="assign" binding="strong">
                  <string>Noto Sans CJK SC</string>
                </edit>
              </match>
              <match target="pattern">
                <test name="prgname" qual="any">
                  <string>steamwebhelper</string>
                </test>
                <edit name="family" mode="assign" binding="strong">
                  <string>Noto Sans CJK SC</string>
                </edit>
              </match>
              <!-- alias prefer 会被 charset 比较压过，这里直接压到族列表首位 -->
              <match target="pattern">
                <test name="family" qual="any">
                  <string>sans-serif</string>
                </test>
                <edit name="family" mode="prepend" binding="strong">
                  <string>WenQuanYi WenQuanYi Bitmap Song</string>
                </edit>
              </match>
              <!-- 点阵只有 16px 一档，更大的字号会被放大成模糊点阵 -->
              <match target="pattern">
                <test name="family" qual="any">
                  <string>WenQuanYi WenQuanYi Bitmap Song</string>
                </test>
                <test name="pixelsize" compare="more">
                  <double>16</double>
                </test>
                <edit name="family" mode="assign" binding="strong">
                  <string>Noto Sans CJK SC</string>
                </edit>
                <edit name="antialias" mode="assign">
                  <bool>true</bool>
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
            "Noto Sans CJK SC"
          ];
          serif = [
            "WenQuanYi WenQuanYi Bitmap Song"
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
