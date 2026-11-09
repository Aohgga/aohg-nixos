{
  flake.modules.nixos.networking = {
    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };
      firewall = {
        enable = true;
      };
      nftables.enable = true;
    };
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    services.resolved.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;

    local.persistence = {
      home.directories = [
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
      system.directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/ssh"
        "/var/lib/NetworkManager"
      ];
    };
  };
}
