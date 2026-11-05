{
  flake.modules.nixos.input-method = { pkgs, ... }: {
    i18n.inputMethod = {
      enable = true;
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mellow-themes
          (fcitx5-rime.override {
            rimeDataPkgs = [ rime-ice ];
          })
        ];
        waylandFrontend = true;
      };
      type = "fcitx5";
    };
    services.libinput.enable = true;
  };
}
