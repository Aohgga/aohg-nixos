{
  flake.modules.homeManager.yazi = { osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".config/yazi"
      ".local/state/yazi"
    ];
    programs.yazi = {
      enable = true;
      package = (pkgs.yazi.override {
        _7zz = pkgs._7zz-rar;
      });

      settings = {
        mgr = {
          sort_by = "natural";
          mouse_events = [ "click" "scroll" ];
        };
        preview = {
          # 够撑满预览面板即可；这块屏是 1920x1080，
          # 更大的值只会让预加载缓存和 CPU 开销成倍增加。
          max_width = 1920;
          max_height = 1080;
        };
        opener.edit = [
          {
            run = "\${EDITOR:-nvim} %s";
            desc = "$EDITOR";
            for = "unix";
            block = true;
          }
          {
            run = "code %s";
            desc = "code";
            for = "windows";
            orphan = true;
          }
          {
            run = "code -w %s";
            desc = "code (block)";
            for = "windows";
            block = true;
          }
        ];
      };

      # 配色由 noctalia 模板生成到 flavors/noctalia.yazi，这里只引用它。
      theme = {
        flavor = {
          dark = "noctalia";
          light = "noctalia";
        };
        icon = {
          conds = [ ];
          dirs = [ ];
          exts = [ ];
          files = [ ];
          globs = [ ];
        };
        mgr.border_symbol = " ";
      };
    };
  };
}
