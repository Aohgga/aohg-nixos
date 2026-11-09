{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth.enable = true;
    local.persistence.system.directories = [ "/var/lib/bluetooth" ];
  };
}
