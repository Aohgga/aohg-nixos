{ lib, ... }:
{
  flake.modules.nixos.MechFonts =
    { ... }:
    {
      fonts = {
        fontconfig.defaultFonts = lib.mkForce {
          emoji = [ "Noto Color Emoji" ];
          monospace = [ "Maple Mono NL NF CN" ];
          sansSerif = [
            "Inter"
            "PingFang SC"
            "Noto Sans CJK SC"
          ];
          serif = [
            "PingFang SC"
            "Noto Serif CJK SC"
          ];
        };
      };
    };
}
