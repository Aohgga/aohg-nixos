{
  flake.modules.homeManager.fish = { osConfig, ... }: {
    home.persistence."${osConfig.aohg.persistence.homeRoot}".directories = [
      ".cache/fish"
      ".config/fish"
      ".local/share/fish"
    ];
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = "";
      };
    };
  };
}
