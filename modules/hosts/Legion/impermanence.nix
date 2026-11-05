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
    # machine-id 持久化
    # tmpfs 根每次开机都会生成新 machine-id，导致 journald 每个 boot
    # 建一个新目录（/var/log/journal/<id>），日志也串不起来。
    # 在 initrd 里、switch-root 之前把持久化副本 bind 到新根的
    # /etc/machine-id，这样 stage-2 的 systemd/journald 一启动看到
    # 的就是稳定 ID；也避免 impermanence persist-files 和
    # systemd-machine-id-setup 抢文件的 activation 冲突。
    # ────────────────────────────────────────────────────────────
    boot.initrd.systemd.mounts = [
      {
        where = "/sysroot/etc/machine-id";
        what = "/sysroot/persistent/etc/machine-id";
        type = "none";
        options = "bind";
        wantedBy = [ "initrd.target" ];
        before = [ "initrd-nixos-activation.service" ];
        unitConfig = {
          DefaultDependencies = false;
          Requires = [ "sysroot.mount" "sysroot-persistent.mount" ];
          After = [ "sysroot.mount" "sysroot-persistent.mount" ];
        };
      }
    ];

    # ────────────────────────────────────────────────────────────
    # 系统级持久化（root 状态）
    # ────────────────────────────────────────────────────────────
    environment.persistence."/persistent" = {
      hideMounts = true;
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
        "/var/lib/private/mihomo"
        "/var/lib/systemd"
        "/var/lib/upower"
        "/var/log"
      ];

      # ──────────────────────────────────────────────────────────
      # 用户级持久化（home 状态）
      # 注意：home 是 tmpfs，没列在这里的东西都会在重启后消失。
      # Music / Pictures / Videos / Games / data 都指向 /data，
      # 由 home-manager 的 home.file 每次开机重建，不在这里 bind。
      # ──────────────────────────────────────────────────────────
      users.aohg = {
        directories = [
          ".android"
          ".cache/appimage-run"
          ".cache/fish"
          ".cache/fontconfig"
          ".cache/noctalia"
          ".config/@deepseek-ai"
          ".config/age"
          ".config/aohg-dotfiles"
          ".config/aohg-nixos"
          ".config/autostart"
          ".config/btop"
          ".config/dconf"
          ".config/DSH Desktop"
          ".config/ELYTerminal"
          ".config/fcitx5"
          ".config/GitHub Desktop"
          ".config/gtk-3.0"
          ".config/gtk-4.0"
          ".config/hypr"
          ".config/ibus"
          ".config/lact"
          ".config/Ladybird"
          ".config/libaccounts-glib"
          ".config/menus"
          ".config/mozilla"
          ".config/mpv-handler/cookies"
          ".config/net.imput.helium"
          ".config/nvim"
          ".config/qBittorrent"
          ".config/qutebrowser"
          ".config/rofi"
          ".config/swayimg"
          ".config/umbriel"
          ".config/VirtualBox"
          ".config/waybar"
          ".config/xsettingsd"
          ".config/zed"
          ".config/zen"
          ".dsh"
          { directory = ".gnupg"; mode = "0700"; }
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
          ".local/share/icons"
          ".local/share/keyrings"
          ".local/share/kwalletd"
          ".local/share/Ladybird"
          ".local/share/nautilus"
          ".local/share/nvim"
          ".local/share/pki"
          ".local/share/plasmalogin"
          ".local/share/qBittorrent"
          ".local/share/qutebrowser"
          ".local/share/Steam"
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
          ".pki"
          { directory = ".ssh"; mode = "0700"; }
          ".steam"
          ".var/app"
          "Applications"
          "Desktop"
          "Documents"
          "Downloads"
          "Projects"
          "VMs"
        ];
        files = [
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
      };
    };
  };
}
