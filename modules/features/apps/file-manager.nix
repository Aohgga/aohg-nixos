{
  flake.modules.homeManager.file-manager = { osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}" = {
      directories = [
        ".local/share/Trash"
        ".local/share/ark"
        ".local/share/dolphin"
      ];
      files = [
        { file = ".config/arkrc"; method = "symlink"; }
        { file = ".config/dolphinrc"; method = "symlink"; }
        { file = ".config/kiorc"; method = "symlink"; }
        { file = ".config/kservicemenurc"; method = "symlink"; }
        { file = ".config/trashrc"; method = "symlink"; }
        { file = ".local/share/user-places.xbel"; method = "symlink"; }
        { file = ".local/state/dolphinstaterc"; method = "symlink"; }
      ];
    };
    home.packages = with pkgs.kdePackages; [
      ark
      dolphin
      dolphin-plugins
      kio-extras
      kio-fuse
    ];
  };
}
