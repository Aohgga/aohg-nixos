{ inputs, ... }:
{
  flake.modules.nixos.denial = {
    imports = [ inputs.denial.nixosModules.default ];
    programs.denial = {
      ddc.enable = true;
      enable = true;
      plugins.enable = true;
      polkitAgent.enable = true;
    };
  };
}
