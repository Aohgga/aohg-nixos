{
  flake.modules.homeManager.swayimg = { lib, pkgs, ... }: {
    home.packages = [ pkgs.swayimg ];

    # 配色跟着 noctalia 主题走：模板渲染到缓存目录，主题（壁纸）变化后重新渲染，
    # 下次启动 swayimg 生效。渲染结果是一个 Lua 片段，由 init.lua 里的 dofile 载入。
    xdg.configFile."noctalia/templates/swayimg/colors.lua".text = ''
      swayimg.text.color = 0xff{{ colors.on_surface.default.hex_stripped }}
      swayimg.viewer.set_window_background(0x99{{ colors.surface.default.hex_stripped }})
      swayimg.gallery.window_color = 0x99{{ colors.surface.default.hex_stripped }}
      swayimg.gallery.unselected_color = 0xff{{ colors.surface_container.default.hex_stripped }}
      swayimg.gallery.selected_color = 0xff{{ colors.surface_container_high.default.hex_stripped }}
      swayimg.gallery.border_color = 0xff{{ colors.primary.default.hex_stripped }}
      swayimg.gallery.mark_color = 0xff{{ colors.primary.default.hex_stripped }}
    '';

    xdg.configFile."swayimg/init.lua".text = ''
      swayimg.text.size = 16

      -- 指定单个文件启动时把同目录的其它图片也加入列表，
      -- 否则 viewer 里的 next/prev（PageUp/PageDown、comma/period）没有目标可切
      swayimg.imagelist.adjacent = true

      -- 主题色没渲染出来时的兜底（半透明黑）
      swayimg.viewer.set_window_background(0x99000000)
      swayimg.gallery.window_color = 0x99000000

      -- 载入 noctalia 渲染的主题色，覆盖上面的兜底
      local cache = os.getenv("XDG_CACHE_HOME") or (os.getenv("HOME") .. "/.cache")
      pcall(dofile, cache .. "/noctalia/swayimg/colors.lua")

      swayimg.viewer.on_key("q", function() swayimg.exit() end)
      swayimg.slideshow.on_key("q", function() swayimg.exit() end)
      swayimg.gallery.on_key("q", function() swayimg.exit() end)

      swayimg.viewer.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)
      swayimg.gallery.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)

      swayimg.viewer.on_key("period", function() swayimg.viewer.open("next") end)
      swayimg.viewer.on_key("comma", function() swayimg.viewer.open("prev") end)
      swayimg.gallery.on_key("period", function() swayimg.gallery.select("right") end)
      swayimg.gallery.on_key("comma", function() swayimg.gallery.select("left") end)
    '';

    # 模板入口按应用追加到 umbriel 写的 config.toml 末尾（同 wl-kbptr 的做法），
    # 这样新加应用的主题配置不用回头改 umbriel.nix。
    xdg.configFile."noctalia/config.toml".text = lib.mkAfter ''
      [theme.templates.user.swayimg]
      input_path  = "$XDG_CONFIG_HOME/noctalia/templates/swayimg/colors.lua"
      output_path = "$XDG_CACHE_HOME/noctalia/swayimg/colors.lua"
    '';
  };
}
