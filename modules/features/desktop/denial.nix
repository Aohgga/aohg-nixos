{ inputs, ... }:
{
  flake.modules.nixos.denial = {
    imports = [ inputs.denial.nixosModules.default ];
    programs.denial = {
      enable = true;
      polkitAgent.enable = true;
      plugins.enable = true;
      ddc.enable = true;
    };
  };
}
