{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts = {
      enableDefaultPackages = false;
      fontconfig = {
        allowBitmaps = true;
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [ "Maple Mono NL NF CN" ];
          sansSerif = [ "Noto Sans CJK SC" ];
          serif = [ "Noto Serif CJK SC" ];
        };
        enable = true;
        hinting.enable = false;
        subpixel = {
          lcdfilter = "default";
          rgba = "rgb";
        };
        useEmbeddedBitmaps = true;
      };
      packages = with pkgs; [
        maple-mono.NL-NF-CN-unhinted
        nerd-fonts.zed-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
      ];
    };
  };
}
