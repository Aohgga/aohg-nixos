{
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
