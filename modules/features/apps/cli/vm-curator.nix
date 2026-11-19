{
  flake.modules.nixos.vm-curator = { pkgs, ... }: {
    environment.systemPackages = [ pkgs. vm-curator ];
  };
}
