{ inputs, ... }:
{
  flake-file.inputs.aohg-pkgs = {
    url = "github:Aohgga/aohg-pkgs";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [ inputs.aohg-pkgs.overlays.default ];
  };
}
