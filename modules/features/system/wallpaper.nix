{
  flake.modules.nixos.wallpaper =
    { config, pkgs, ... }:
    let
      userHome = config.users.users.${config.local.primaryUser.name}.home;
      # plasmalogin 读取这里（greeter 用户可读）
      greeterWallpaper = "/var/lib/plasmalogin/wallpaper.png";
      # noctalia 的 wallpaper_changed hook 写到这里（用户可写）
      userWallpaper = "${userHome}/.local/share/plasmalogin/wallpaper.png";
    in
    {
      # plasmalogin 的壁纸配置在 plasmalogin.conf；/etc 每次启动重建，
      # 所以这里声明式写入固定路径，换壁纸时不需要再改配置。
      environment.etc."plasmalogin.conf".text = ''
        [Greeter]
        WallpaperPluginId=org.kde.image

        [Greeter][Wallpaper][org.kde.image][General]
        Image=file://${greeterWallpaper}
      '';

      # 由 noctalia 的 hooks.wallpaper_changed 调用：
      # /run/current-system/sw/bin/noctalia-wallpaper-hook
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "noctalia-wallpaper-hook" ''
          set -euo pipefail
          src="''${NOCTALIA_WALLPAPER_PATH:-}"
          if [ -z "$src" ] || [ ! -r "$src" ]; then
            exit 0
          fi

          dst="${userWallpaper}"
          mkdir -p "$(dirname "$dst")"
          tmp="$dst.tmp.$$"
          cp -f "$src" "$tmp"
          chmod 0644 "$tmp"
          mv -f "$tmp" "$dst"
        '')
      ];

      # 文件变化时同步到 greeter 可读的位置。
      # 不设 PathExists：文件一直存在会被反复触发，容易撞上 systemd 的
      # start limit（上次 failed 就是这个原因）；首次同步由 service 开机执行。
      systemd.paths.plasmalogin-wallpaper = {
        pathConfig = {
          PathChanged = userWallpaper;
          Unit = "plasmalogin-wallpaper.service";
        };
        unitConfig.StartLimitIntervalSec = 0;
        wantedBy = [ "multi-user.target" ];
      };

      systemd.services.plasmalogin-wallpaper = {
        serviceConfig.Type = "oneshot";
        script = ''
          if [ -r ${userWallpaper} ]; then
            ${pkgs.coreutils}/bin/install -Dm644 ${userWallpaper} ${greeterWallpaper}
          fi
        '';
        unitConfig.StartLimitIntervalSec = 0;
        wantedBy = [ "multi-user.target" ];
      };
    };
}
