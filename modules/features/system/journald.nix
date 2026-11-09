{
  flake.modules.nixos.journald = { pkgs, ... }: {
    # /etc/machine-id 不持久化，每次开机都会变；journald 按 machine-id 建目录，
    # 不回收会无限增长。
    systemd.services.journal-prune = {
      description = "Drop journal directories from previous machine-ids";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-journald.service" ];
      path = [ pkgs.coreutils ];
      serviceConfig.Type = "oneshot";
      script = ''
        current=$(cat /etc/machine-id)
        for dir in /var/log/journal/*/; do
          [ -d "$dir" ] || continue
          [ "''${dir%/}" = "/var/log/journal/$current" ] || rm -rf "$dir"
        done
      '';
    };

    services.journald.settings.Journal.SystemMaxUse = "1G";

    local.persistence.system.directories = [ "/var/log" ];
  };
}
