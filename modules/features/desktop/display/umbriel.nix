{ inputs, ... }:
{
  flake-file.inputs = {
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    umbriel.url = "github:noctalia-dev/umbriel/cachix";
  };

  flake.modules.nixos.umbriel = { pkgs, ... }: {
    imports = [
      inputs.noctalia.nixosModules.default
      inputs.umbriel.nixosModules.default
    ];

    nix.settings = {
      substituters = [
        "https://noctalia.cachix.org"
        "https://umbriel.cachix.org"
      ];
      "trusted-public-keys" = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      ];
    };

    programs = {
      noctalia = {
        enable = true;
        systemd.enable = true;
      };
      umbriel = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      gcc
      python3
      playerctl
      coreutils
    ];

    local.persistence.home.directories = [
      ".cache/noctalia"
      ".config/noctalia"
      ".config/umbriel"
      ".local/state/noctalia"
    ];
  };

  flake.modules.homeManager.umbriel = {
    imports = [ inputs.umbriel.homeModules.default ];
    programs.umbriel.enable = true;
  };
}
