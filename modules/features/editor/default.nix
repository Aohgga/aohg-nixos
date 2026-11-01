{
  flake.modules.homeManager.editor = { pkgs, ... }: {
    programs = {
      zed-editor = {
        enable = true;
      };
      neovim = {
        enable = true;
        sideloadInitLua = true;
        extraPackages = with pkgs; [
          gcc
        ];
      };
    };
    home.packages = with pkgs; [
      nixd
      nil
      git
    ];
  };
}
