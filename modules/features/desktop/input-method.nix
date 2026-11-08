{
  flake.modules.nixos.input-method = { pkgs, ... }: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mellow-themes
          (fcitx5-rime.override {
            rimeDataPkgs = [ rime-ice ];
          })
        ];
        waylandFrontend = true;
      };
    };
    services.libinput.enable = true;

    aohg.persistence = {
      home.directories = [
        ".config/fcitx5"
        ".local/share/fcitx5"
      ];
      home.files = [ { file = ".config/kxkbrc"; } ];
    };
  };

  flake.modules.homeManager.input-method = {
    xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
      patch:
        __include: rime_ice_suggestion:/
    '';
  };
}
