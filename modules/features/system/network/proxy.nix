{
  flake.modules.nixos.proxy = { config, ... }: {
    networking.proxy = {
      default = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost,::1";
    };
    age.secrets."mihomo-config" = {
      file = ../../../../secrets/mihomo-config.age;
    };
    services.mihomo = {
      enable = true;
      configFile = config.age.secrets."mihomo-config".path;
      tunMode = false;
    };

    # TUN 的回包源地址来自 fake-ip 段，strict rpfilter 会直接丢弃
    networking.firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ "Meta" ];
    };

    local.persistence.system.directories = [ "/var/lib/private/mihomo" ];
  };
}
