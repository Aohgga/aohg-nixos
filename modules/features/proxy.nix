{
  flake.modules.nixos.proxy = { config, ... }: {
    networking.proxy = {
      default = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,::1";
    };
    age.secrets.mihomoConfig = {
      file = ../../secrets/mihomo/config.yaml.age;
    };
    services.mihomo = {
      enable = true;
      configFile = config.age.secrets.mihomoConfig.path;
      tunMode = false;
    };
  };
}
