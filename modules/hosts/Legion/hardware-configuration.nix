{
  flake.modules.nixos.LegionHardware = { config, lib, modulesPath, ... }: {
    imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
      ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" "ntsync" ];
    boot.extraModulePackages = [ ];
    boot.blacklistedKernelModules = [ "nouveau" "ideapad_laptop" ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/b35e382a-92d8-4a14-85f9-8e354d79ecf0";
        fsType = "xfs";
        options = [ "rw" "relatime" "inode64" "logbufs=8" "logbsize=32k" "noquota" ];
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/4273-BACB";
        fsType = "vfat";
        options = [ "rw" "relatime" "fmask=0077" "dmask=0077" "codepage=437" "iocharset=ascii" "shortname=mixed" "utf8" "errors=remount-ro" ];
      };

    fileSystems."/data" =
      { device = "/dev/disk/by-uuid/737bd4df-35d2-4d10-942f-d212021435cb";
        fsType = "xfs";
        options = [ "rw" "relatime" "inode64" "logbufs=8" "logbsize=32k" "noquota" ];
      };

    swapDevices = lib.mkForce [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
