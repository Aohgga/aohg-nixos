{ inputs, ... }:
{
  flake-file.inputs.denial.url = "github:denialwm/denial";

  flake.modules.nixos.denial = {
    imports = [ inputs.denial.nixosModules.default ];

    nix.settings = {
      substituters = [ "https://denial.cachix.org" ];
      "trusted-public-keys" = [
        "denial.cachix.org-1:wd8YTnvPmugFrtdMJWtR1XdVknR3/g2nmBJkT+vAruo="
      ];
    };

    programs.denial = {
      enable = true;
      polkitAgent.enable = true;
      plugins.enable = true;
      ddc.enable = true;
    };

    aohg.persistence.home.directories = [
      ".config/denial"
      ".config/denial-home"
    ];
  };
}
