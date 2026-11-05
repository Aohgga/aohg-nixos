{ inputs, ... }:
{
  flake.modules.nixos.umbriel = { pkgs, ... }: {
    imports = [
      inputs.noctalia.nixosModules.default
      inputs.umbriel.nixosModules.default
    ];
    services.gvfs.enable = true;
    programs.dconf.enable = true;
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };
    programs.umbriel = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-umbriel;
    };
    xdg.portal.extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

  flake.modules.homeManager.umbriel = {
    imports = [ inputs.umbriel.homeModules.default ];
    programs.umbriel.enable = true;
  };
}
