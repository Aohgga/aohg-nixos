{
  flake.modules.nixos.networking = {
    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };
      firewall = {
        enable = true;
        allowedTCPPorts = [ 53317 ];
        allowedUDPPorts = [ 53317 ];
        trustedInterfaces = [ "mihomo" ];
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

    aohg.persistence = {
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
