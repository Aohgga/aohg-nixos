{
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
