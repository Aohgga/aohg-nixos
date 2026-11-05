{ self, ... }:
{
  flake.modules.homeManager.Legion = { config, ... }: {
    imports = [
      self.modules.homeManager.base
      self.modules.homeManager.LegionUmbriel
      self.modules.homeManager.LegionApps
      self.modules.homeManager.zen-browser
    ];
    home.stateVersion = "26.05";

    # home 是 tmpfs：/data 的快捷方式和 dotfiles 的符号链接每次开机重建。
    # XDG 目录本身不自动 mkdir，避免和下面的符号链接冲突。
    xdg.userDirs.createDirectories = false;
    home.file = {
      "data".source = config.lib.file.mkOutOfStoreSymlink "/data";
      "Pictures".source = config.lib.file.mkOutOfStoreSymlink "/data/Pictures";
      "Videos".source = config.lib.file.mkOutOfStoreSymlink "/data/Videos";
      "Games".source = config.lib.file.mkOutOfStoreSymlink "/data/Games";
      "Music".source = config.lib.file.mkOutOfStoreSymlink "/data/Music";
      ".local/share/backgrounds".source = config.lib.file.mkOutOfStoreSymlink "/data/wallpapers";

      ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/aohg-dotfiles/yazi";
      ".config/mako".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/aohg-dotfiles/mako_1";
      ".config/mango".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/aohg-dotfiles/mango";
      ".config/niri".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/aohg-dotfiles/niri";
      ".config/scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/aohg-dotfiles/scripts";
    };
  };
}
