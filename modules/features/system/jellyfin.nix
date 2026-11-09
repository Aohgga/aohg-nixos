{
  flake.modules.nixos.jellyfin = { config, ... }: {
    services.jellyfin = {
      enable = true;
      user = config.local.primaryUser.name;
      openFirewall = true;
    };
  };
}
