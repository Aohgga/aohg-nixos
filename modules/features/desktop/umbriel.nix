{ inputs, ... }:
{
  flake.modules.nixos.umbriel = { pkgs, ... }: {
    imports = [
      inputs.umbriel.nixosModules.default
      inputs.noctalia.nixosModules.default
    ];
    programs.umbriel = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-umbriel;
    };
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };
    xdg.portal.extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    services.gvfs.enable = true;
    programs.dconf.enable = true;
  };

  flake.modules.homeManager.umbriel = {
    imports = [ inputs.umbriel.homeModules.default ];
    programs.umbriel.enable = true;
  };
}
