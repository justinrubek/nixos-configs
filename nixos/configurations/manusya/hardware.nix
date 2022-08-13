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

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8cebcf74-68af-4d6e-b8e1-16a63cef5c6c";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/04FD-7745";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/46fcc499-a282-4cd0-b3ba-b78c94cf593b";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # nvidia settings
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    nvidiaPersistenced = true;
    modesetting.enable = true;
  };
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = ["nvidia" "intel"];
}
