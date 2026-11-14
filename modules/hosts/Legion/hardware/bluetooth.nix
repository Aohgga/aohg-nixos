{
  flake.modules.nixos.LegionBluetooth = {
    hardware.bluetooth.enable = true;
    local.persistence.system.directories = [ "/var/lib/bluetooth" ];
  };
}
