{
  flake.modules.nixos.ttyper = {
    aohg.persistence.home.directories = [ ".config/ttyper" ];
  };

  flake.modules.homeManager.ttyper = {
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
