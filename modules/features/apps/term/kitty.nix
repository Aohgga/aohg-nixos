{
  flake.modules.homeManager.kitty = { osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [ ".config/kitty" ];
    home.packages = [
      pkgs.kitty
    ];
    xdg.configFile."kitty/kitty.conf" = {
      text = ''
        font_family Maple Mono NL NF CN
        font_size 10
        shell fish
        shell_integration no-rc
        background_blur 1
        window_margin_width 5
        window_padding_width 3 10 3
        initial_window_height 768
        initial_window_width 1024
        remember_window_size no
        include themes/noctalia.conf
      '';
      onChange = "${pkgs.procps}/bin/pkill -USR1 -u $USER kitty || true";
    };
    programs.fish.interactiveShellInit = ''
      if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION "no-rc"
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
      end
    '';
  };
}
