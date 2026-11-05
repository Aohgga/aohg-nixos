{
  flake.modules.nixos.appimage = { pkgs, ... }: {
    programs.appimage = {
      binfmt = true;
      enable = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.libepoxy
        ];
      };
    };
  };
}
