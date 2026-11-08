{
  flake.modules.nixos.editor = {
    aohg.persistence = {
      home.directories = [
        ".config/nvim"
        ".config/zed"
        ".local/share/nvim"
        ".local/share/zed"
        ".local/state/nvim"
      ];
      home.files = [ { file = ".gitconfig"; } ];
    };
  };

  flake.modules.homeManager.editor = { pkgs, ... }: {
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
