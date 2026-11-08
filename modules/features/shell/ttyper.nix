{
  flake.modules.homeManager.ttyper = { osConfig, ... }: {
    home.persistence."${osConfig.aohg.persistence.homeRoot}".directories = [ ".config/ttyper" ];
    programs.ttyper = {
      enable = true;
      settings = {
        default_language = "english1000";
        theme = {
          border_type = "rounded";
        };
      };
    };
  };
}
