{ inputs, ... }:
{
  flake-file.inputs.helium-flake = {
    url = "github:oxcl/nix-flake-helium-browser";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.helium = { osConfig, ... }: {
    imports = [ inputs.helium-flake.homeModules.default ];
    programs.helium.enable = true;

    home.persistence."${osConfig.aohg.persistence.homeRoot}".directories = [ ".config/net.imput.helium" ];
  };
}
