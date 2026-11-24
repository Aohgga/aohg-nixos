{
  flake.modules.homeManager.mpv =
    {
      config,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    {
      home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
        ".config/mpv"
        ".config/mpv-handler"
        ".local/state/mpv"
      ];
      home.packages = with pkgs; [
        (mpv.override {
          scripts = [
            bilibili-mpv
            mpvScripts.modernz
          ];
        })
        mpv-handler
        yt-dlp
      ];
      xdg.configFile = {
        "mpv/mpv.conf".text = ''
          vo=gpu-next
          hwdec=vulkan
          gpu-api=vulkan
          gpu-context=waylandvk
          profile=gpu-hq
          sub-auto=fuzzy
          osd-bar=no
          osd-font=Inter
          osc=no
          save-position-on-quit=yes
        '';
        # ModernZ 的官方中文语言包（extras/locale 里的 zh 部分）。
        "mpv/script-opts/modernz-locale.json".source = ../../../../config/modernz/modernz-locale.json;

        # osc_color 是 OSC 背景（模糊+描边形成的渐变）和提示框的底色，固定黑色，
        # 不跟主题色走；进度条/高亮/章节点仍用主题的 primary。
        # ModernZ 的设置由 noctalia 模板渲染，配色跟随当前壁纸主题；渲染结果写到
        # ~/.config/mpv/script-opts/modernz.conf（见下面的 [theme.templates.user.modernz]）。
        "noctalia/templates/modernz/modernz.conf".text = ''
          language=zh
          layout=mini
          font=Inter

          osc_color=#000000
          window_title_color={{ colors.on_surface.default.hex }}
          window_controls_color={{ colors.on_surface.default.hex }}
          title_color={{ colors.on_surface.default.hex }}
          cache_info_color={{ colors.on_surface_variant.default.hex }}
          seekbar_cache_color={{ colors.on_surface_variant.default.hex }}
          seekbarfg_color={{ colors.primary.default.hex }}
          seekbarbg_color={{ colors.surface_container.default.hex }}
          seek_handle_color={{ colors.primary.default.hex }}
          seek_handle_border_color={{ colors.background.default.hex }}
          time_color={{ colors.on_surface.default.hex }}
          chapter_title_color={{ colors.on_surface.default.hex }}
          side_buttons_color={{ colors.on_surface.default.hex }}
          middle_buttons_color={{ colors.on_surface.default.hex }}
          playpause_color={{ colors.on_surface.default.hex }}
          held_element_color={{ colors.on_surface_variant.default.hex }}
          hover_effect_color={{ colors.primary.default.hex }}
          thumbnail_box_color={{ colors.background.default.hex }}
          thumbnail_box_outline={{ colors.outline_variant.default.hex }}
          nibble_color={{ colors.primary.default.hex }}
          nibble_current_color={{ colors.on_surface.default.hex }}
          ab_loop_color={{ colors.tertiary.default.hex }}
        '';

        "mpv-handler/config.toml".text = ''
          mpv = "${config.home.profileDirectory}/bin/mpv"
          ytdl = "${pkgs.yt-dlp}/bin/yt-dlp"
          proxy = "${osConfig.networking.proxy.default}"
        '';

        "noctalia/config.toml".text = lib.mkAfter ''
          [theme.templates.user.modernz]
          input_path  = "$XDG_CONFIG_HOME/noctalia/templates/modernz/modernz.conf"
          output_path = "$XDG_CONFIG_HOME/mpv/script-opts/modernz.conf"
        '';
      };

      # 文件管理器（luciole/yazi 经 xdg-open）会读 mpv.desktop 的
      # --player-operation-mode=pseudo-gui（即 --idle），播放完不退出；
      # 覆盖成普通模式，让播放结束即关闭。
      xdg.dataFile."applications/mpv.desktop".text =
        lib.replaceStrings [ "Exec=mpv --player-operation-mode=pseudo-gui -- %U" ] [ "Exec=mpv -- %U" ]
          (builtins.readFile "${pkgs.mpv}/share/applications/mpv.desktop");
    };
}
