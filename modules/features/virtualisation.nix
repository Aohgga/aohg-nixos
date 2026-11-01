{
  flake.modules.nixos.virtualisation = {
    virtualisation.virtualbox = {
      host = {
        enable = true;
        enableHardening = true;
        enableKvm = false;
        addNetworkInterface = true;
        enableExtensionPack = true;
      };
      guest = {
        enable = true;
        use3rdPartyModules = true;
      };
    };
    users.extraGroups.vboxusers.members = [ "aohg" ];
    systemd.units."dev-vboxguest.device".text = ''
      [Unit]
      ConditionVirtualization=oracle
    '';
  };
}
