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

  fileSystems = {
    "/" = {
      device = "fpool/local/root";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D3E4-CF9F";
      fsType = "vfat";
    };
    "/nix" = {
      device = "fpool/local/nix";
      fsType = "zfs";
    };
    "/home" = {
      device = "fpool/safe/home";
      fsType = "zfs";
    };
    "/persist" = {
      device = "fpool/safe/persist";
      fsType = "zfs";
    };
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  hardware = {
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.rocmPackages.clr
        pkgs.rocmPackages.clr.icd
      ];
    };
  };

  services = {
    blueman.enable = true;
    xserver.videoDrivers = ["amdgpu"];
  };
}
