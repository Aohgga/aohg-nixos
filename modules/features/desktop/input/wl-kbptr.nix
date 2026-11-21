{
  flake.modules.nixos.wl-kbptr = { pkgs, ... }: {
    # 走 wlr-virtual-pointer 协议操作指针，不碰 /dev/uinput，与 ydotool 并行无冲突。
    # 上游没有标签位置和字重的选项，补丁加 [general] label_offset（正值向上）并把标签字体固定为 bold。
    environment.systemPackages = [
      (pkgs.wl-kbptr.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./wl-kbptr/label-tweaks.patch ];
      }))
    ];

    # 配置由 noctalia 模板渲染，目录持久化让渲染结果跨重启保留。
    local.persistence.home.directories = [ ".config/wl-kbptr" ];
  };

  flake.modules.homeManager.wl-kbptr = { lib, ... }: {
    # wl-kbptr 的配置不支持 include，配色和字体只能整份交给 noctalia 重渲染。
    # 点阵字体只有 13/15/16px 三档原生尺寸，其他字号都会被缩放成模糊字形，所以字体
    # 改用 fontconfig 的 monospace（Legion 上是 Terminess），并把各模式的字号钉死成
    # 同一个值：所有标签大小一致，且任意字号都是矢量渲染，不会发虚。
    xdg.configFile."noctalia/templates/wl-kbptr/config".text = ''
      [general]
      # 本地补丁提供的项：标签整体上移的像素数，0 为垂直居中
      label_offset=3
      modes=floating,click

      [mode_tile]
      label_color={{ colors.on_surface.default.hex }}ff
      label_font_family=monospace
      label_font_size=16 100% 16
      label_select_color={{ colors.primary.default.hex }}ff
      selectable_bg_color={{ colors.surface.default.hex }}99
      selectable_border_color={{ colors.primary.default.hex }}ff
      unselectable_bg_color={{ colors.surface.default.hex }}80

      [mode_floating]
      label_color={{ colors.on_surface.default.hex }}ff
      label_font_family=monospace
      label_font_size=16 100% 16
      label_select_color={{ colors.primary.default.hex }}ff
      selectable_bg_color={{ colors.surface.default.hex }}99
      selectable_border_color={{ colors.primary.default.hex }}ff
      source=detect
      unselectable_bg_color={{ colors.surface.default.hex }}80

      [mode_bisect]
      even_area_bg_color={{ colors.surface.default.hex }}99
      even_area_border_color={{ colors.primary.default.hex }}ff
      history_border_color={{ colors.secondary.default.hex }}cc
      label_color={{ colors.on_surface.default.hex }}ff
      label_font_family=monospace
      label_font_size=16
      odd_area_bg_color={{ colors.surface_container_high.default.hex }}99
      odd_area_border_color={{ colors.tertiary.default.hex }}ff
      pointer_color={{ colors.primary.default.hex }}ff
      unselectable_bg_color={{ colors.surface.default.hex }}80

      [mode_split]
      area_bg_color={{ colors.surface.default.hex }}99
      bg_color={{ colors.surface.default.hex }}80
      history_border_color={{ colors.secondary.default.hex }}cc
      horizontal_color={{ colors.tertiary.default.hex }}ff
      pointer_color={{ colors.primary.default.hex }}ff
      vertical_color={{ colors.primary.default.hex }}ff
    '';

    # 模板只在装了 wl-kbptr 的主机上注册，所以追加到 umbriel 写的 config.toml 末尾。
    xdg.configFile."noctalia/config.toml".text = lib.mkAfter ''
      [theme.templates.user.wl_kbptr]
      input_path  = "$XDG_CONFIG_HOME/noctalia/templates/wl-kbptr/config"
      output_path = "$XDG_CONFIG_HOME/wl-kbptr/config"
    '';
  };
}
