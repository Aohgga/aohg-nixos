{
  flake.modules.nixos.networking = {
    networking = {
      firewall = {
        allowedTCPPorts = [ 53317 ];
        allowedUDPPorts = [ 53317 ];
        enable = true;
        trustedInterfaces = [ "mihomo" ];
      };
      networkmanager.enable = true;
      nftables.enable = true;
    };
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
