{
  flake.modules.homeManager.kitty = { pkgs, ... }: {
    programs.kitty = {
      enable = true;
      font = {
        name = "Maple Mono NL NF CN";
        package = pkgs.maple-mono.NL-NF-CN-unhinted;
        size = 10;
      };
      shellIntegration.enableFishIntegration = true;
      settings = {
        shell = "fish";
        background_blur = "1";
        window_padding_width = "3 10 3";
        window_margin_width = "5";
        remember_window_size = "no";
        initial_window_width = "1024";
        initial_window_height = "768";
        include = "themes/noctalia.conf";
      };
    };
  };
}
