{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth.enable = true;
    aohg.persistence.system.directories = [ "/var/lib/bluetooth" ];
  };
}
