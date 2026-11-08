{
  flake.modules.nixos.proxy = { config, ... }: {
    networking.proxy = {
      default = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,::1";
    };
    age.secrets."mihomo-config" = {
      file = ../../secrets/mihomo-config.age;
    };
    services.mihomo = {
      configFile = config.age.secrets."mihomo-config".path;
      enable = true;
      tunMode = false;
    };

    aohg.persistence.system.directories = [ "/var/lib/private/mihomo" ];
  };
}
