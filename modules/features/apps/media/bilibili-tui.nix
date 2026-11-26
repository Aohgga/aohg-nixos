{
  flake.modules.homeManager.bilibili-tui = { osConfig, pkgs, ... }: {
    home.packages = [ pkgs.bilibili-tui ];
    # config.json、credentials.json 与 CDN 历史都在这里，登录扫码的 Cookie 也在其中
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".config/bilibili-tui"
    ];
  };
}
