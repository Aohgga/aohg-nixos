{
  flake.modules.nixos.file-manager = {
    aohg.persistence = {
      home.directories = [
        ".local/share/Trash"
        ".local/share/ark"
        ".local/share/dolphin"
      ];
      home.files = [
        { file = ".config/arkrc"; }
        { file = ".config/dolphinrc"; }
        { file = ".config/kiorc"; }
        { file = ".config/kservicemenurc"; }
        { file = ".config/trashrc"; }
        { file = ".local/share/user-places.xbel"; }
        { file = ".local/state/dolphinstaterc"; }
      ];
    };
  };

  flake.modules.homeManager.file-manager = { pkgs, ... }: {
    home.packages = with pkgs.kdePackages; [
      ark
      dolphin
      dolphin-plugins
      kio-extras
      kio-fuse
    ];
  };
}
