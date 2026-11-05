{ inputs, ... }:
let
  # ── 设备 UUID（与 hardware-configuration.nix 一致）──
  rootDevice = "/dev/disk/by-uuid/cbada62e-5ebd-4b9d-8a3f-a71a6a75ed98";
  homeDevice = "/dev/disk/by-uuid/a7d1b984-7af8-49f4-aefb-aa5f53a6c59b";
in
{
  flake.modules.nixos.MechImpermanence = { utils, ... }: {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    # ────────────────────────────────────────────
    # 1. 持久化存储池挂载
    # ────────────────────────────────────────────

    # /persistent：root 盘上的系统级持久化
    fileSystems."/persistent" = {
      device = rootDevice;
      fsType = "btrfs";
      options = [ "subvol=persistent" "compress=zstd:3" "noatime" ];
      neededForBoot = true;
    };

    # /persist-home：home 盘上的用户级持久化
    fileSystems."/persist-home" = {
      device = homeDevice;
      fsType = "btrfs";
      options = [ "subvol=home-persist" "compress=zstd:3" "noatime" ];
      neededForBoot = true;
    };

    # ────────────────────────────────────────────
    # 2. initrd 阶段：每次启动重置 root 和 home-root 子卷
    # ────────────────────────────────────────────

    boot.initrd.systemd = {

      # 重置根子卷
      services.wipe-root = {
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        wantedBy = [ "initrd.target" ];
        before = [ "sysroot.mount" ];
        requires = [ "${utils.escapeSystemdPath rootDevice}.device" ];
        after = [
          "${utils.escapeSystemdPath rootDevice}.device"
          "local-fs-pre.target"
        ];
        script = ''
          mkdir /btrfs_tmp
          mount ${rootDevice} /btrfs_tmp
          trap 'umount /btrfs_tmp' EXIT

          if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            btrfs subvolume delete --recursive "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
        '';
      };

      # 重置 hoom-root 子卷
      services.wipe-home-root = {
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        wantedBy = [ "initrd.target" ];
        before = [ "sysroot.mount" ];
        requires = [ "${utils.escapeSystemdPath homeDevice}.device" ];
        after = [
          "${utils.escapeSystemdPath homeDevice}.device"
          "local-fs-pre.target"
        ];
        script = ''
          mkdir /home_btrfs_tmp
          mount ${homeDevice} /home_btrfs_tmp
          trap 'umount /home_btrfs_tmp' EXIT

          if [[ -e /home_btrfs_tmp/home-root ]]; then
            mkdir -p /home_btrfs_tmp/old_home_roots
            timestamp=$(date --date="@$(stat -c %Y /home_btrfs_tmp/home-root)" "+%Y-%m-%d_%H:%M:%S")
            mv /home_btrfs_tmp/home-root "/home_btrfs_tmp/old_home_roots/$timestamp"
          fi

          for i in $(find /home_btrfs_tmp/old_home_roots/ -maxdepth 1 -mtime +30); do
            btrfs subvolume delete --recursive "$i"
          done

          btrfs subvolume create /home_btrfs_tmp/home-root
        '';
      };
    };

    # ────────────────────────────────────────────
    # 3. 系统级持久化（root 盘的 /persistent）
    # ────────────────────────────────────────────

    # 注意：/etc/machine-id、/etc/adjtime 不做 `files` 持久化。
    # impermanence 的 persist-files 在 /etc 已有同名文件时会让 activation 失败，
    # 而这两项都可以在启动时重新生成（machine-id 每次 boot 会变）。
    environment.persistence."/persistent" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/ssh"
        "/var/lib/AccountsService"
        "/var/lib/bluetooth"
        "/var/lib/colord"
        "/var/lib/flatpak"
        "/var/lib/NetworkManager"
        "/var/lib/nixos"
        "/var/lib/plasmalogin"
        "/var/lib/private/mihomo"
        "/var/lib/systemd"
        "/var/lib/upower"
        "/var/log"
      ];
    };

    # ────────────────────────────────────────────
    # 4. 用户级持久化（home 盘的 /persist-home）
    #    注意：impermanence 的 users.<name> 存储路径固定为
    #    /persist-home/home/aohg，不能改成 /persist-home/aohg
    # ────────────────────────────────────────────

    environment.persistence."/persist-home" = {
      hideMounts = true;
      users.aohg = {
        directories = [
          ".android"
          ".cache/appimage-run"
          ".cache/fish"
          ".cache/fontconfig"
          ".cache/noctalia"
          ".config/@deepseek-ai"
          ".config/age"
          ".config/aohg-nixos"
          ".config/autostart"
          ".config/btop"
          ".config/dconf"
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
          ".config/yazi"
          ".config/zed"
          ".dsh"
          { directory = ".gnupg"; mode = "0700"; }
          ".local/bin"
          ".local/share/app.getlux.com.sakuracat.app"
          ".local/share/applications"
          ".local/share/ark"
          ".local/share/backgrounds"
          ".local/share/color-schemes"
          ".local/share/com.epicgames.eglv2"
          ".local/share/dolphin"
          ".local/share/ElyOffice"
          ".local/share/fcitx5"
          ".local/share/fish"
          ".local/share/flatpak"
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
          ".local/state/dolphinstaterc"
          ".local/state/go-musicfox"
          ".local/state/mpv"
          ".local/state/noctalia"
          ".local/state/nvim"
          ".local/state/wireplumber"
          ".pki"
          { directory = ".ssh"; mode = "0700"; }
          ".var/app"
          "AppImages"
          "Desktop"
          "Documents"
          "Downloads"
          "Games"
          "Music"
          "Pictures"
          "Projects"
          "Videos"
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
