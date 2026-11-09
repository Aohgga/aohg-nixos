{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts = {
      enableDefaultPackages = false;
      packages = with pkgs; [
        maple-mono.NL-NF-CN-unhinted
        nerd-fonts.zed-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [ "Noto Sans CJK SC" ];
          serif = [ "Noto Serif CJK SC" ];
          monospace = [ "Maple Mono NL NF CN" ];
          emoji = [ "Noto Color Emoji" ];
        };
        hinting.enable = false;
        subpixel = {
          rgba = "rgb";
          lcdfilter = "default";
        };
        allowBitmaps = true;
        useEmbeddedBitmaps = true;
      };
    };

    local.persistence.home.directories = [ ".local/share/fonts" ];
  };
}
