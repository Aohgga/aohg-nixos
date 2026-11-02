{
  flake.modules.nixos.proxy = { config, ... }: {
    age.secrets.mihomoConfig = {
      file = ../../secrets/mihomo/config.yaml.age;
    };
    services.mihomo = {
      enable = true;
      configFile = config.age.secrets.mihomoConfig.path;
      tunMode = true;
    };
  };
}
