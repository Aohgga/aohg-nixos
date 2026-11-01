{
  flake.modules.nixos.input-method = { pkgs, ... }: {
    services.libinput.enable = true;
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
  };
}
