{
  flake.modules.nixos.display-manager = { config, lib, ... }: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      passwordlessSyncUsers = [ config.local.primaryUser.name ];
      settings = {
        session.default = "Umbriel";
        user.default = config.local.primaryUser.name;
      };
    };

    # initial_session 只在开机后首次运行；注销或会话结束后 greetd 回落到
    # default_session（noctalia-greeter）。有 initial_session 时模块默认关掉
    # Restart，这里强制保留，避免 GPU 未就绪时失败后不再重试。
    services.greetd.settings.initial_session = {
      command = "${config.programs.umbriel.package}/bin/start-umbriel";
      user = config.local.primaryUser.name;
    };
    services.greetd.restart = lib.mkForce true;

    local.persistence.system.directories = [ "/var/lib/noctalia-greeter" ];

    # greetd 可能在 GPU 就绪前失败；默认 5 次/10 秒的 start-limit 会在 1 秒内
    # 用完，之后 systemd 不再重试，只能手动重启。改为无限重试、间隔 1 秒。
    systemd.services.greetd = {
      unitConfig.StartLimitIntervalSec = 0;
      serviceConfig.RestartSec = 1;
    };
  };
}
