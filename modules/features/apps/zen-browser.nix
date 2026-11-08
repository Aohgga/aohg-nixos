{ inputs, ... }:
{
  flake-file.inputs.zen-browser = {
    url = "github:0xc000022070/zen-browser-flake";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  flake.modules.homeManager.zen-browser = {
    imports = [ inputs.zen-browser.homeModules.beta ];
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };
  };
}
