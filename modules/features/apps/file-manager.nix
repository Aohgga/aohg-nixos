{ inputs, ... }:
{
  flake-file.inputs.strata = {
    url = "github:lgse/strata";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.file-manager =
    { pkgs, ... }:
    let
      strata = inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      environment.systemPackages = [ strata ];
      local.persistence.home.directories = [
        ".config/strata"
        ".local/share/strata"
        ".local/share/Trash"
        ".local/state/strata"
      ];
      services.dbus.packages = [ strata.fileManagerService ];
      xdg.portal.extraPortals = [ strata.fileChooserPortal ];
    };
}
