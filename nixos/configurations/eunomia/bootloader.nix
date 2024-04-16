{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # loader.efi.efiSysMountPoint = "/boot/efi";

    initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
        "thunderbolt"
        "xhci_pci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };
}
