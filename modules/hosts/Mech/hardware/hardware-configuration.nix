{
  flake.modules.nixos.MechHardware = { config, lib, modulesPath, ... }: {
    imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
      ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/cbada62e-5ebd-4b9d-8a3f-a71a6a75ed98";
        fsType = "btrfs";
        options = [ "subvol=root" ];
      };

    fileSystems."/nix" =
      { device = "/dev/disk/by-uuid/cbada62e-5ebd-4b9d-8a3f-a71a6a75ed98";
        fsType = "btrfs";
        options = [ "subvol=nix" ];
      };

    fileSystems."/home" =
      { device = "/dev/disk/by-uuid/a7d1b984-7af8-49f4-aefb-aa5f53a6c59b";
        fsType = "btrfs";
        options = [ "subvol=home-root" ];
        neededForBoot = true;
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/12CE-A600";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };


    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
