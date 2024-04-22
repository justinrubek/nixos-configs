{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e2856d09-507b-419a-a0e1-e0f1c994c91a";
      fsType = "btrfs";
      options = ["subvol=@"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3174-393F";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
