{
  # swayimg 5.7 的字体渲染有两个点和点阵字体冲突，而 Legion 的 fontconfig 默认就是
  # 点阵（Terminess 内嵌 1bpp 点阵、中文回退到文泉驿点阵宋体），所以只在这台机器上打补丁：
  #   1. rasterize_glyph() 只认 8bpp 灰度和 BGRA 位图，遇到 1bpp 单色位图仍按“1 字节/像素”
  #      memcpy，源行 pitch 只有 1~2 字节，于是字形被逐行错切，整屏文字变成斜纹；
  #   2. 固定尺寸点阵在非原生字号下 FT_Set_Pixel_Sizes 会失败，但失败被忽略，之后
  #      FT_Load_Glyph 返回空位图，字符变成占位空白（swayimg 还会把空位图当成功）。
  # 补丁按位展开单色位图，并让 set_size 失败的字形返回 nullptr，好让回退链继续找下一个字体。
  flake.modules.nixos.LegionSwayimg = { ... }: {
    nixpkgs.overlays = [
      (final: prev: {
        swayimg = prev.swayimg.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./swayimg/mono-bitmap.patch ];
        });
      })
    ];
  };
}
