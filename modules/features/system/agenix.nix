{ inputs, ... }:
{
  flake-file.inputs.agenix = {
    url = "github:ryantm/agenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.agenix = { pkgs, ... }: {
    imports = [ inputs.agenix.nixosModules.default ];
    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    local.persistence.home.directories = [ ".config/age" ];
  };
}
