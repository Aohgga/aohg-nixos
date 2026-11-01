{ inputs, ... }:
{
  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [ inputs.aohg-pkgs.overlays.default ];
  };
}
