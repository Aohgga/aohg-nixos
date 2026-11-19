{
  flake.modules.nixos.vm-curator = { config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      qemu_kvm
      vm-curator
    ];
    local.persistence.home.directories = [
      ".config/vm-curator"
      "vm-space"
    ];
    users.extraGroups.kvm.members = [ config.local.primaryUser.name ];
  };
}
