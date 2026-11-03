{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
  ];
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
    };
  };
  flake.modules.nixos.agenix = { pkgs, ... }: {
    imports = [ inputs.agenix.nixosModules.default ];
    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    environment.systemPackages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
