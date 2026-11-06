{ ... }:
let
  # home 是 tmpfs：未列入的路径重启后消失，/data 与 ~/Documents 等由 home-manager 重建。
  homeDirectories = [
    ".android"
    ".cache/appimage-run"
    ".cache/fish"
    ".cache/fontconfig"
    ".cache/noctalia"
    ".config/age"
    ".config/aohg-nixos"
    ".config/autostart"
    ".config/btop"
    ".config/dconf"
    ".config/denial"
    ".config/denial-home"
    ".config/ELYTerminal"
    ".config/environment.d"
    ".config/fcitx5"
    ".config/fish"
    ".config/fontconfig"
    ".config/go-musicfox"
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".config/ibus"
    ".config/kitty"
    ".config/lact"
    ".config/Ladybird"
    ".config/libaccounts-glib"
    ".config/menus"
    ".config/mpv"
    ".config/mpv-handler"
    ".config/net.imput.helium"
    ".config/noctalia"
    ".config/nvim"
    ".config/qBittorrent"
    ".config/swayimg"
    ".config/systemd/user"
    ".config/ttyper"
    ".config/umbriel"
    ".config/xdg-desktop-portal"
    ".config/xsettingsd"
    ".config/yazi"
    ".config/zed"
    ".dsh"
    {
      directory = ".gnupg";
      mode = "0700";
    }
    ".local/bin"
    ".local/share/app.getlux.com.sakuracat.app"
    ".local/share/applications"
    ".local/share/ark"
    ".local/share/color-schemes"
    ".local/share/com.epicgames.eglv2"
    ".local/share/dolphin"
    ".local/share/ElyOffice"
    ".local/share/fcitx5"
    ".local/share/fish"
    ".local/share/fonts"
    ".local/share/go-musicfox"
    ".local/share/gpu-screen-recorder"
    ".local/share/keyrings"
    ".local/share/kwalletd"
    ".local/share/Ladybird"
    ".local/share/nautilus"
    ".local/share/nvim"
    ".local/share/org.localsend.localsend_app"
    ".local/share/pki"
    ".local/share/plasmalogin"
    ".local/share/qBittorrent"
    ".local/share/themes"
    ".local/share/Trash"
    ".local/share/umu"
    ".local/share/zed"
    ".local/state/dolphinstaterc"
    ".local/state/go-musicfox"
    ".local/state/mpv"
    ".local/state/noctalia"
    ".local/state/nvim"
    ".local/state/wireplumber"
    ".local/state/yazi"
    ".pki"
    {
      directory = ".ssh";
      mode = "0700";
    }
    "Desktop"
    "Projects"
  ];

  homeFiles = [
    ".bash_history"
    ".config/arkrc"
    ".config/darklyrc"
    ".config/dolphinrc"
    ".config/kcminputrc"
    ".config/kdeglobals"
    ".config/kglobalshortcutsrc"
    ".config/kiorc"
    ".config/kservicemenurc"
    ".config/kwalletrc"
    ".config/kxkbrc"
    ".config/mimeapps.list"
    ".config/trashrc"
    ".gitconfig"
    ".local/share/recently-used.xbel"
    ".local/share/user-places.xbel"
  ];
in
{
  flake.modules.nixos.persistence = { config, lib, ... }: {
    options.aohg.persistence.homeRoot = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "/persistent";
    };

    config = {
      environment.persistence = lib.mkMerge [
        {
          "/persistent".directories = [
            "/etc/lact"
            "/etc/NetworkManager/system-connections"
            "/etc/ssh"
            "/var/lib/AccountsService"
            "/var/lib/bluetooth"
            "/var/lib/colord"
            "/var/lib/NetworkManager"
            "/var/lib/nixos"
            "/var/lib/plasmalogin"
            "/var/lib/private/mihomo"
            "/var/lib/systemd"
            "/var/lib/upower"
            "/var/log"
          ];
        }

        (lib.mkIf (config.aohg.persistence.homeRoot != null) {
          ${config.aohg.persistence.homeRoot}.users.aohg = {
            directories = homeDirectories;
            files = homeFiles;
          };
        })
      ];
    };
  };
}
