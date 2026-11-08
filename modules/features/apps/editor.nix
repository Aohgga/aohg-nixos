{
  flake.modules.homeManager.editor = { osConfig, pkgs, ... }: {
    home.persistence."${osConfig.aohg.persistence.homeRoot}" = {
      directories = [
        ".config/nvim"
        ".config/zed"
        ".local/share/nvim"
        ".local/share/zed"
        ".local/state/nvim"
      ];
      files = [ { file = ".gitconfig"; method = "symlink"; } ];
    };
    home.packages = with pkgs; [
      git
      nil
      nixd
    ];
    programs.neovim = {
      enable = true;
      extraPackages = with pkgs; [
        gcc
      ];
      sideloadInitLua = true;
    };
    programs.zed-editor.enable = true;
  };
}
