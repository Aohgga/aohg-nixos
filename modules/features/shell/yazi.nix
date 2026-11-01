{
  flake.modules.homeManager.yazi = { pkgs, ... }: {
    programs.yazi = {
      enable = true;
      package = (pkgs.yazi.override {
        _7zz = pkgs._7zz-rar;
      });
    };
  };
}
