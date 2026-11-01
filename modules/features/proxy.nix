{
  flake.modules.nixos.proxy = { config, ... }: {
    sops.secrets.mihomoConfig = {
      format = "yaml";
      sopsFile = ../../secrets/mihomo.yaml;
      key = "";
      restartUnits = [ "mihomo.service" ];
    };
    services.mihomo = {
      enable = true;
      configFile = config.sops.secrets.mihomoConfig.path;
      tunMode = true;
    };
  };
}
