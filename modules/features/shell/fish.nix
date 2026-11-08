{
  flake.modules.nixos.fish = {
    aohg.persistence.home.directories = [
      ".cache/fish"
      ".config/fish"
      ".local/share/fish"
    ];
  };

  flake.modules.homeManager.fish = {
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = "";
      };
    };
  };
}
