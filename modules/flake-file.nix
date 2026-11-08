{ inputs, ... }:
{
  imports = [ inputs.flake-file.flakeModules.default ];

  flake-file.inputs = {
    flake-file.url = "github:denful/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
}
