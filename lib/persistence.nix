# 两台机器共用的持久化条目，host 模块在此基础上追加差异项。
# 被 modules/features/impermanence*.nix 里的 environment.persistence 使用。
{
  # 系统级
  systemDirs = [
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

  # 用户级目录
  userDirs = [
    # 文档 / 项目
    "Desktop"
    "Documents"
    "Downloads"
    "Projects"
    "VMs"

    # 密钥 / 身份 / 其他
    ".android"
    ".dsh"
    { directory = ".gnupg"; mode = "0700"; }
    ".pki"
    { directory = ".ssh"; mode = "0700"; }
    ".var/app"

    # .config
    ".config/age"
    ".config/aohg-nixos"
    ".config/autostart"
    ".config/btop"
    ".config/dconf"
    ".config/@deepseek-ai"
    ".config/DSH Desktop"
    ".config/ELYTerminal"
    ".config/fcitx5"
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".config/ibus"
    ".config/lact"
    ".config/Ladybird"
    ".config/libaccounts-glib"
    ".config/menus"
    ".config/mpv-handler/cookies"
    ".config/net.imput.helium"
    ".config/nvim"
    ".config/qBittorrent"
    ".config/swayimg"
    ".config/umbriel"
    ".config/VirtualBox"
    ".config/xsettingsd"
    ".config/zed"

    # .local
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
    ".local/share/pki"
    ".local/share/plasmalogin"
    ".local/share/qBittorrent"
    ".local/share/themes"
    ".local/share/Trash"
    ".local/share/umu"
    ".local/share/zed"
    ".local/state/go-musicfox"
    ".local/state/mpv"
    ".local/state/noctalia"
    ".local/state/nvim"
    ".local/state/wireplumber"

    # .cache
    ".cache/appimage-run"
    ".cache/fish"
    ".cache/fontconfig"
    ".cache/noctalia"
  ];

  # 用户级文件
  userFiles = [
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
}
