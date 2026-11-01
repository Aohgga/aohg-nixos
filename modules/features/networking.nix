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
    systemd.services.NetworkManager-wait-online.enable = false;
    services.openssh.enable = true;
  };
}
