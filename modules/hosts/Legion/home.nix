{ self, ... }:
{
  flake.modules.homeManager.Legion = { config, lib, pkgs, ... }: {
    imports = [
      self.modules.homeManager.base
      self.modules.homeManager.LegionFonts
      self.modules.homeManager.LegionUmbriel
      self.modules.homeManager.zen-browser
    ];

    gtk.cursorTheme = lib.mkForce {
      name = "miku-cursor-linux";
      package = pkgs.miku-cursors;
      size = 24;
    };

    # home 是 tmpfs：/data 的快捷方式和 dotfiles 的符号链接每次开机重建。
    # XDG 目录本身不自动 mkdir，避免和下面的符号链接冲突。
    home.file = {
      ".local/share/backgrounds".source = config.lib.file.mkOutOfStoreSymlink "/data/wallpapers";
      "Documents".source = config.lib.file.mkOutOfStoreSymlink "/data/Documents";
      "Downloads".source = config.lib.file.mkOutOfStoreSymlink "/data/Downloads";
      "Games".source = config.lib.file.mkOutOfStoreSymlink "/data/Games";
      "Music".source = config.lib.file.mkOutOfStoreSymlink "/data/Music";
      "Pictures".source = config.lib.file.mkOutOfStoreSymlink "/data/Pictures";
      "Videos".source = config.lib.file.mkOutOfStoreSymlink "/data/Videos";
      "data".source = config.lib.file.mkOutOfStoreSymlink "/data";
    };
    xdg.userDirs.createDirectories = false;
  };
}
