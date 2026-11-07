{ ... }:
let
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
    ".config/ttyper"
    ".config/umbriel"
    ".config/xdg-desktop-portal"
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
    ".local/share/nvim"
    ".local/share/org.localsend.localsend_app"
    ".local/share/pki"
    ".local/share/plasmalogin"
    ".local/share/qBittorrent"
    ".local/share/Trash"
    ".local/share/umu"
    ".local/share/zed"
    ".local/state/go-musicfox"
    ".local/state/mpv"
    ".local/state/noctalia"
    ".local/state/nvim"
    ".local/state/wireplumber"
    ".local/state/yazi"
    {
      directory = ".ssh";
      mode = "0700";
    }
    "Desktop"
    "Projects"
  ];

  # 单文件持久化改用符号链接而不是 bind mount：
  # KConfig / Qt 的 QSaveFile 会解析符号链接，把临时文件写到目标目录再 rename，
  # 所以应用仍能正常保存；bind mount 下 rename 会返回 EBUSY，写入被静默丢弃。
  # 注意：目标文件必须已存在于持久化目录，否则符号链接悬空、写入无效。
  homeFiles = [
    { file = ".bash_history"; method = "symlink"; }
    { file = ".config/arkrc"; method = "symlink"; }
    { file = ".config/darklyrc"; method = "symlink"; }
    { file = ".config/dolphinrc"; method = "symlink"; }
    { file = ".config/kcminputrc"; method = "symlink"; }
    { file = ".config/kdeglobals"; method = "symlink"; }
    { file = ".config/kglobalshortcutsrc"; method = "symlink"; }
    { file = ".config/kiorc"; method = "symlink"; }
    { file = ".config/kservicemenurc"; method = "symlink"; }
    { file = ".config/kwalletrc"; method = "symlink"; }
    { file = ".config/kxkbrc"; method = "symlink"; }
    { file = ".config/mimeapps.list"; method = "symlink"; }
    { file = ".config/trashrc"; method = "symlink"; }
    { file = ".gitconfig"; method = "symlink"; }
    { file = ".local/share/recently-used.xbel"; method = "symlink"; }
    { file = ".local/share/user-places.xbel"; method = "symlink"; }
    { file = ".local/state/dolphinstaterc"; method = "symlink"; }
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
          "/persistent" = {
            directories = [
              "/etc/lact"
              "/etc/NetworkManager/system-connections"
              "/etc/ssh"
              "/var/lib/AccountsService"
              "/var/lib/bluetooth"
              "/var/lib/colord"
              "/var/lib/NetworkManager"
              "/var/lib/nixos"
              "/var/lib/plasmalogin"
              "/var/lib/power-profiles-daemon"
              "/var/lib/private/mihomo"
              "/var/lib/systemd"
              "/var/lib/upower"
              "/var/log"
            ];
          };
        }

        (lib.mkIf (config.aohg.persistence.homeRoot != null) {
          ${config.aohg.persistence.homeRoot}.users.aohg = {
            directories = homeDirectories;
            files = homeFiles;
          };
        })
      ];

      # homeFiles 是符号链接，目标文件不存在时链接悬空、应用写入会静默丢失；
      # 开机先按清单补出空文件，新加的条目不用手动 touch。
      systemd.tmpfiles.rules = lib.optionals (config.aohg.persistence.homeRoot != null) (
        map (f: "f ${config.aohg.persistence.homeRoot}/home/aohg/${f.file} 0600 aohg users -") homeFiles
      );
    };
  };
}
