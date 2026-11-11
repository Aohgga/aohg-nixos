{
  flake.modules.nixos.display-manager = { config, ... }: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      passwordlessSyncUsers = [ config.local.primaryUser.name ];
      settings = {
        session.default = "Umbriel";
        user.default = config.local.primaryUser.name;
      };
    };

    local.persistence.system.directories = [ "/var/lib/noctalia-greeter" ];

    # greetd 可能在 GPU 就绪前失败；默认 5 次/10 秒的 start-limit 会在 1 秒内
    # 用完，之后 systemd 不再重试，只能手动重启。改为无限重试、间隔 1 秒。
    systemd.services.greetd = {
      unitConfig.StartLimitIntervalSec = 0;
      serviceConfig.RestartSec = 1;
    };
  };
}
