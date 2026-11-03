{ inputs, ... }:
let
  # Legion 的 nvme0n1p2（当前根分区，XFS），见 hosts/Legion/hardware-configuration.nix
  rootDevice = "/dev/disk/by-uuid/b35e382a-92d8-4a14-85f9-8e354d79ecf0";
in
{
  # ────────────────────────────────────────────────────────────────────────
  # tmpfs 根 + tmpfs /home，系统状态和用户状态都持久化在同一个分区
  # （nvme0n1p2）。原根分区整块挂到 /persistent，nix store 通过
  # /persistent/nix 的 bind mount 原地保留，不需要搬数据。
  # ────────────────────────────────────────────────────────────────────────
  flake.modules.nixos.LegionImpermanence = { lib, ... }: {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    fileSystems = {
      # 根：tmpfs，每次开机清空
      "/" = lib.mkForce {
        device = "none";
        fsType = "tmpfs";
        neededForBoot = true;
        options = [ "mode=0755" "size=25%" ];
      };

      # /home：tmpfs，登录后再把需要的目录 bind 回来
      "/home" = {
        device = "none";
        fsType = "tmpfs";
        neededForBoot = true;
        options = [ "mode=0755" "size=25%" ];
      };

      # 原来的根分区 = 持久化分区
      "/persistent" = {
        device = rootDevice;
        fsType = "xfs";
        neededForBoot = true;
        options = [
          "rw"
          "relatime"
          "inode64"
          "logbufs=8"
          "logbsize=32k"
          "noquota"
        ];
      };

      # nix store 还在原分区的 /nix 目录里，bind 到 /nix
      "/nix" = {
        device = "/persistent/nix";
        fsType = "none";
        neededForBoot = true;
        options = [ "bind" ];
        depends = [ "/persistent" ];
      };
    };

    # ────────────────────────────────────────────────────────────
    # 系统级持久化（root 状态）
    # ────────────────────────────────────────────────────────────
    environment.persistence."/persistent" = {
      hideMounts = true;
      directories = [
        # NixOS 自身
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/var/log"

        # 网络 / 蓝牙 / 登录管理器
        "/var/lib/NetworkManager"
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/lib/plasmalogin"
        "/var/lib/AccountsService"
        "/var/lib/upower"
        "/var/lib/colord"

        # 应用状态
        "/var/lib/jellyfin"
        "/var/lib/private/mihomo"
        "/etc/ssh"
        "/etc/lact"
      ];

      # ──────────────────────────────────────────────────────────
      # 用户级持久化（home 状态）
      # 注意：home 是 tmpfs，没列在这里的东西都会在重启后消失。
      # ──────────────────────────────────────────────────────────
      users.aohg = {
        directories = [
          # 文档目录（Pictures/Videos/Games 是指向 /data 的符号链接，
          # 由 home-manager 的 home.file 每次开机重建，不在这里 bind）
          "Documents"
          "Downloads"
          "Desktop"
          "Music"
          "Projects"
          "VMs"
          "Applications"

          # 密钥 / 身份
          { directory = ".ssh"; mode = "0700"; }
          { directory = ".gnupg"; mode = "0700"; }
          ".pki"
          ".local/share/keyrings"

          # 配置仓库
          ".config/aohg-nixos"
          ".config/aohg-dotfiles"
          ".config/nvim"
          ".config/age"

          # 桌面 / 输入法 / 主题
          ".config/autostart"
          ".config/btop"
          ".config/dconf"
          ".config/fcitx5"
          ".config/gtk-3.0"
          ".config/gtk-4.0"
          ".config/ibus"
          ".config/lact"
          ".config/libaccounts-glib"
          ".config/menus"
          ".config/swayimg"
          ".config/umbriel"
          ".config/xsettingsd"
          ".config/hypr"
          ".config/rofi"
          ".config/waybar"

          # 应用数据
          ".config/@deepseek-ai"
          ".config/DSH Desktop"
          ".config/ELYTerminal"
          ".config/GitHub Desktop"
          ".config/Ladybird"
          ".config/VirtualBox"
          ".config/mozilla"
          ".config/qBittorrent"
          ".config/qutebrowser"
          ".config/zed"
          ".config/zen"
          ".config/net.imput.helium"
          ".config/mpv-handler/cookies"

          # 游戏 / 容器
          ".steam"
          ".local/share/Steam"
          ".local/share/umu"
          ".local/share/com.epicgames.eglv2"
          ".var/app"
          ".android"
          ".dsh"

          # 字体 / 图标 / 壁纸 / 主题
          ".local/share/fonts"
          ".local/share/backgrounds"
          ".local/share/color-schemes"
          ".local/share/themes"
          ".local/share/icons"
          ".local/bin"

          # shell / 编辑器 / 桌面环境状态
          ".local/share/fish"
          ".local/share/nvim"
          ".local/share/fcitx5"
          ".local/share/applications"
          ".local/share/dolphin"
          ".local/share/ark"
          ".local/share/plasmalogin"
          ".local/share/kwalletd"
          ".local/share/ElyOffice"
          ".local/share/Ladybird"
          ".local/share/go-musicfox"
          ".local/share/nautilus"
          ".local/share/qBittorrent"
          ".local/share/gpu-screen-recorder"
          ".local/share/pki"
          ".local/share/app.getlux.com.sakuracat.app"
          ".local/share/Trash"
          ".local/share/qutebrowser"

          ".local/state/noctalia"
          ".local/state/wireplumber"
          ".local/state/mpv"
          ".local/state/nvim"
          ".local/state/go-musicfox"

          # 缓存里值得留的部分
          ".cache/appimage-run"
          ".cache/fontconfig"
          ".cache/fish"
          ".cache/noctalia"
        ];
        files = [
          ".bash_history"
          ".gitconfig"

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

          ".local/share/recently-used.xbel"
          ".local/share/user-places.xbel"
        ];
      };
    };
  };
}
