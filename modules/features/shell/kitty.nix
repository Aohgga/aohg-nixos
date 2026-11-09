{
  flake.modules.homeManager.kitty = { osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [ ".config/kitty" ];
    programs.kitty = {
      enable = true;
      font = {
        name = "Maple Mono NL NF CN";
        package = pkgs.maple-mono.NL-NF-CN-unhinted;
        size = 10;
      };
      settings = {
        background_blur = "1";
        include = "themes/noctalia.conf";
        initial_window_height = "768";
        initial_window_width = "1024";
        remember_window_size = "no";
        shell = "fish";
        window_margin_width = "5";
        window_padding_width = "3 10 3";
      };
      shellIntegration.enableFishIntegration = true;
    };
  };
}
