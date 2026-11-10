{ lib, ... }:
{
  flake.modules.nixos.LegionFonts = {
    fonts.fontconfig = {
      antialias = false;
      defaultFonts = lib.mkForce {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "UnifontExMono"
          "Maple Mono NL NF CN"
        ];
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
      # Steam 的 CEF 走 Skia，渲染不了 bitmap-only 字体；在 pattern 阶段
      # 换成矢量字体，避免它拿到点阵后回退成缺字。
      localConf = ''
        <match target="pattern">
          <test name="prgname" qual="any">
            <string>steamwebhelper</string>
          </test>
          <edit name="family" mode="prepend" binding="strong">
            <string>Noto Sans CJK SC</string>
          </edit>
        </match>
      '';
      subpixel.rgba = lib.mkForce "none";
    };
  };

  flake.modules.homeManager.LegionFonts =
    { lib, ... }:
    {
      gtk.font = lib.mkForce {
        name = "WenQuanYi WenQuanYi Bitmap Song";
        size = 11;
      };
      programs.kitty.font = lib.mkForce {
        name = "UnifontExMono";
        size = 12;
      };
    };
}
