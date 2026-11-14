{
  flake.modules.nixos.MechBluetooth = {
    hardware.bluetooth.enable = true;
    local.persistence.system.directories = [ "/var/lib/bluetooth" ];
  };
}
