{
  flake.modules.nixos.networking = {
    networking = {
      networkmanager.enable = true;
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
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
