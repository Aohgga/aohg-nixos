{
  flake.modules.homeManager.prismlauncher = { osConfig, pkgs, ... }: {
    home.persistence."${osConfig.local.persistence.homeRoot}".directories = [
      ".local/share/PrismLauncher"
    ];
    home.packages = [
      (pkgs.prismlauncher.override {
        jdks = [ pkgs.jdk25 ];
      })
    ];
  };
}
