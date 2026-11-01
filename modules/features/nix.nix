{
  flake.modules.nixos.nix = {
    nix = {
      channel.enable = false;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        trusted-users = [ "root" "aohg" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };
    nixpkgs.config.allowUnfree = true;
    documentation.nixos.enable = false;
  };
}
