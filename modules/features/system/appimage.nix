{
  flake.modules.nixos.appimage = { pkgs, ... }: {
    programs.appimage = {
      enable = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.libepoxy
        ];
      };
      binfmt = true;
    };

    aohg.persistence.home.directories = [ ".cache/appimage-run" ];
  };
}
