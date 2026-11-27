{
  flake.modules.homeManager.splayer-next = { osConfig, pkgs, ... }: {
    home.packages = [ pkgs.splayer-next ];
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".config/SPlayer-Next"
    ];
  };
}
