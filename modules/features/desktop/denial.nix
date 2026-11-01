{ inputs, ... }:
{
  flake.modules.nixos.denial = {
    imports = [
      inputs.denial.nixosModules.default
    ];
    programs.denial = {
      enable = true;
      plugins.enable = true;
      polkitAgent.enable = true;
      ddc.enable = true;
    };
  };
}
