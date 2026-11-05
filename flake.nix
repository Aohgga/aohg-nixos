{
  description = "Aohg's NixOS configuration (Dendritic, multi-host)";

  # 缓存配置统一放在 modules/features/nix.nix 的 nix.settings 里，
  # 避免 flake nixConfig 每次换用户（aohg/root）都触发信任询问。

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umbriel.url = "github:noctalia-dev/umbriel/cachix";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    denial.url = "github:denialwm/denial";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    aohg-pkgs = {
      url = "github:Aohgga/aohg-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deepseek-harness.url = "github:moraxyc/deepseek-harness.nix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      # modules/ 下每个 .nix 文件都是 flake-parts 模块，
      # 自动收集 flake.modules.<class>.<name>，不需要手工 import。
      imports = [ (inputs.import-tree ./modules) ];

      # 只有这一种系统，perSystem 的输出（formatter 等）也只生成它。
      systems = [ "x86_64-linux" ];

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt;
      };
    };
}
