{
  flake.modules.homeManager.splayer-next = { osConfig, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".config/SPlayer-Next"
    ];
  };
}
