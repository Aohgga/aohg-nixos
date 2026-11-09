{
  flake.modules.nixos.localsend = {
    networking.firewall = {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
  };

  flake.modules.homeManager.localsend = { pkgs, ... }: {
    home.packages = [ pkgs.localsend ];
  };
}
