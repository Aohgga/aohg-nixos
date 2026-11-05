{
  flake.modules.nixos.proxy = { config, ... }: {
    age.secrets.mihomoConfig = {
      file = ../../secrets/mihomo/config.yaml.age;
    };
    networking.proxy = {
      default = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,::1";
    };
    services.mihomo = {
      configFile = config.age.secrets.mihomoConfig.path;
      enable = true;
      tunMode = false;
    };
  };
}
