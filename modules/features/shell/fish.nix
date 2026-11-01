{
  flake.modules.homeManager.fish = {
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = "";
      };
    };
  };
}
