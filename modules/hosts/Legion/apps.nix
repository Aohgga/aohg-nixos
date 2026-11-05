{
  flake.modules.homeManager.LegionApps = { pkgs, ... }: {
    home.packages = with pkgs; [
      localsend
    ];
  };
}
