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
              <!-- 点阵只有 16px 一档：更大的字号会被放大、粗体会被合成，
                   两者都比矢量更糊。把这两类请求换回 Noto 及其真粗体。 -->
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
              <match target="pattern">
                <test name="family" qual="any">
                  <string>WenQuanYi WenQuanYi Bitmap Song</string>
                </test>
                <test name="weight" compare="more_eq">
                  <const>bold</const>
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
          sansSerif = [ "Noto Sans CJK SC" ];
          serif = [ "Noto Serif CJK SC" ];
        };
        hinting = {
          enable = lib.mkForce true;
          style = "full";
        };
        subpixel.rgba = lib.mkForce "none";
      };
    };

  flake.modules.homeManager.LegionFonts =
    { lib, ... }:
    {
      gtk.font = lib.mkForce {
        name = "WenQuanYi WenQuanYi Bitmap Song";
        size = 12;
      };
      programs.kitty.font = lib.mkForce {
        name = "Unifont";
        size = 12;
      };
    };
}
