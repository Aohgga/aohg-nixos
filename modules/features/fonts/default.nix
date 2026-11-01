{
  flake.modules.nixos.fonts = { pkgs, lib, ... }: {
    fonts = lib.mkForce {
      enableDefaultPackages = false;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        maple-mono.NL-NF-CN-unhinted
        nerd-fonts.zed-mono
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [ "Noto Sans CJK SC" ];
          serif = [ "Noto Serif CJK SC" ];
          monospace = [ "Maple Mono NL NF CN" ];
          emoji = [ "Noto Color Emoji" ];
        };
        hinting = {
          enable = false;
          style = "full";
          autohint = false;
        };
        subpixel = {
          rgba = "rgb";
          lcdfilter = "default";
        };
        useEmbeddedBitmaps = true;
        allowBitmaps = true;
      };
    };
  };
}
