{
  flake.modules.nixos.environment = {
    environment.sessionVariables = {
      EDITOR = "nvim";
      GTK_CSD = "0";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORMTHEME = "kde";
    };
    programs.nix-ld.enable = true;

    local.persistence.home.directories = [ ".local/bin" ];
  };
}
