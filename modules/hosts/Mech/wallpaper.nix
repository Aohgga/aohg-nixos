{ ... }:
let
  user = "aohg";
  # 用户可写的固定位置：noctalia 的 wallpaper_changed hook 把图拷到这里
  userWallpaper = "/home/${user}/.local/share/plasmalogin/wallpaper.png";
  # greeter 可读的位置
  greeterWallpaper = "/var/lib/plasmalogin/wallpaper.png";
in
{
  flake.modules.nixos.MechWallpaper = { pkgs, ... }: {
    # plasmalogin 的壁纸配置在 plasmalogin.conf；/etc 每次启动重建，
    # 所以这里只写固定路径，换壁纸时不需要再改配置。
    environment.etc."plasmalogin.conf".text = ''
      [Greeter]
      WallpaperPluginId=org.kde.image

      [Greeter][Wallpaper][org.kde.image][General]
      Image=file://${greeterWallpaper}
    '';

    # 由 noctalia 的 hooks.wallpaper_changed 调用（设置里填这个路径）：
    # /run/current-system/sw/bin/noctalia-wallpaper-hook
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "noctalia-wallpaper-hook" ''
        set -euo pipefail
        src="''${NOCTALIA_WALLPAPER_PATH:-}"
        if [ -z "$src" ] || [ ! -r "$src" ]; then
          exit 0
        fi

        dst="$HOME/.local/share/plasmalogin/wallpaper.png"
        mkdir -p "$(dirname "$dst")"
        tmp="$dst.tmp.$$"
        cp -f "$src" "$tmp"
        chmod 0644 "$tmp"
        mv -f "$tmp" "$dst"
      '')
    ];

    # 启动时兜底同步一次
    systemd.tmpfiles.rules = [
      "d /var/lib/plasmalogin 0750 plasmalogin plasmalogin -"
      "C+ ${greeterWallpaper} 0644 plasmalogin plasmalogin - ${userWallpaper}"
    ];

    # 换壁纸后立刻同步到 greeter 的目录，不需要重启或重建
    systemd.paths.plasmalogin-wallpaper = {
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        PathChanged = userWallpaper;
        Unit = "plasmalogin-wallpaper.service";
      };
    };

    systemd.services.plasmalogin-wallpaper = {
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.coreutils}/bin/install -Dm644 ${userWallpaper} ${greeterWallpaper}
      '';
    };
  };
}
