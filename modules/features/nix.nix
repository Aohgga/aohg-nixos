{
  flake.modules.nixos.nix = {
    nix = {
      channel.enable = false;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        trusted-users = [ "root" "aohg" ];
        # 让 flake 里声明的 cachix 真正生效（flake nixConfig 默认会被忽略）
        substituters = [
          "https://denial.cachix.org"
          "https://noctalia.cachix.org"
          "https://umbriel.cachix.org"
          "https://deepseek-harness-nix.cachix.org"
        ];
        "trusted-public-keys" = [
          "denial.cachix.org-1:wd8YTnvPmugFrtdMJWtR1XdVknR3/g2nmBJkT+vAruo="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
          "deepseek-harness-nix.cachix.org-1:5NrkwLN9veNMhiINtU5ZeV4isXFhFsOwn6Ms7J1M+TA="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
    nixpkgs.config.allowUnfree = true;
    documentation.nixos.enable = false;
  };
}
