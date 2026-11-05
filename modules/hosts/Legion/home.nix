{ self, ... }:
{
  flake.modules.homeManager.Legion = { config, ... }: {
    imports = [
      self.modules.homeManager.base
      self.modules.homeManager.LegionApps
      self.modules.homeManager.LegionUmbriel
      self.modules.homeManager.zen-browser
    ];
    home.stateVersion = "26.05";

    # home 是 tmpfs：/data 的快捷方式和 dotfiles 的符号链接每次开机重建。
    # XDG 目录本身不自动 mkdir，避免和下面的符号链接冲突。
    home.file = {
      ".config/mako".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/aohg-dotfiles/mako_1";
      ".config/mango".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/aohg-dotfiles/mango";
      ".config/niri".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/aohg-dotfiles/niri";
      ".config/scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/aohg-dotfiles/scripts";
      ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/aohg-dotfiles/yazi";
      ".local/share/backgrounds".source = config.lib.file.mkOutOfStoreSymlink "/data/wallpapers";
      "Games".source = config.lib.file.mkOutOfStoreSymlink "/data/Games";
      "Music".source = config.lib.file.mkOutOfStoreSymlink "/data/Music";
      "Pictures".source = config.lib.file.mkOutOfStoreSymlink "/data/Pictures";
      "Videos".source = config.lib.file.mkOutOfStoreSymlink "/data/Videos";
      "data".source = config.lib.file.mkOutOfStoreSymlink "/data";
    };
    xdg.userDirs.createDirectories = false;
  };
}
