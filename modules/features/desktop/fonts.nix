{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts = {
      enableDefaultPackages = false;
      packages = with pkgs; [
        inter
        maple-mono.NL-NF-CN-unhinted
        nerd-fonts.zed-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        unifontexmono
        # 上游 OTB 的 cmap 标成 MS Symbol，kitty 取不到字形，这里改成 Unicode 编码；
        # kitty 的等宽后备要 12pt 点阵，另存一个 family 名，避免 fontconfig 先选 10pt
        (runCommand "wqy-bitmap-song-unicode" { } ''
          mkdir -p $out/share/fonts/otb
          ${python3}/bin/python3 - ${wqy-bitmap-song}/share/fonts/otb/*.otb <<'PY'
          import os
          import struct
          import sys

          out = os.path.join(os.environ["out"], "share/fonts/otb")
          os.makedirs(out, exist_ok=True)
          for src in sys.argv[1:]:
              data = bytearray(open(src, "rb").read())
              num_tables = struct.unpack(">H", data[4:6])[0]
              cmap = None
              for i in range(num_tables):
                  off = 12 + i * 16
                  if data[off:off + 4] == b"cmap":
                      cmap = struct.unpack(">I", data[off + 8:off + 12])[0]
              if cmap is None:
                  raise SystemExit("no cmap table in " + src)
              records = struct.unpack(">H", data[cmap + 2:cmap + 4])[0]
              for j in range(records):
                  rec = cmap + 4 + j * 8
                  if struct.unpack(">HH", data[rec:rec + 4]) == (3, 0):
                      struct.pack_into(">HH", data, rec, 0, 3)
              base = os.path.basename(src)
              with open(os.path.join(out, base), "wb") as f:
                  f.write(data)
              if base != "wenquanyi_12pt.otb":
                  continue
              name_table = None
              for i in range(num_tables):
                  off = 12 + i * 16
                  if data[off:off + 4] == b"name":
                      name_table = struct.unpack(">I", data[off + 8:off + 12])[0]
              if name_table is None:
                  raise SystemExit("no name table in " + src)
              count, string_offset = struct.unpack(">HH", data[name_table + 2:name_table + 6])
              family = "WenQuanYi Bitmap Song 12pt Mono".encode("utf-16-be")
              for j in range(count):
                  rec = name_table + 6 + j * 12
                  platform, _, _, name_id, length, offset = struct.unpack(">HHHHHH", data[rec:rec + 12])
                  if platform == 3 and name_id in (1, 4):
                      if length != len(family):
                          raise SystemExit("unexpected name record length in " + src)
                      start = name_table + string_offset + offset
                      data[start:start + length] = family
              with open(os.path.join(out, "wenquanyi_12pt_mono.otb"), "wb") as f:
                  f.write(data)
          PY
        '')
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [ "Noto Sans CJK SC" ];
          serif = [ "Noto Serif CJK SC" ];
          monospace = [ "Maple Mono NL NF CN" ];
          emoji = [ "Noto Color Emoji" ];
        };
        hinting.enable = false;
        subpixel = {
          rgba = "rgb";
          lcdfilter = "default";
        };
        allowBitmaps = true;
        useEmbeddedBitmaps = true;
      };
    };

    local.persistence.home.directories = [ ".local/share/fonts" ];
  };
}
