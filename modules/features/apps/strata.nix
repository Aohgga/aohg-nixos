{ inputs, ... }:
{
  flake-file.inputs.strata = {
    url = "github:lgse/strata";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.strata =
    { pkgs, ... }:
    let
      strata = inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      environment.systemPackages = [ strata ];
      services.dbus.packages = [ strata.fileManagerService ];
      xdg.portal.extraPortals = [ strata.fileChooserPortal ];
    };
}
