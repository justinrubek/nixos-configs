{
  pkgs,
  lib,
  self,
  ...
}: {
  systemd.network = {
    enable = true;
    networks.default = {
      matchConfig.Name = "en*";
      networkConfig.DHCP = "yes";
    };
  };

  networking = rec {
    hostName = "bunky";
    hostId = builtins.substring 0 8 (builtins.hashString "md5" hostName);
    useNetworkd = false;
    useDHCP = false;
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "ext4";
    };

    "/" = {
      device = "tank/rootfs";
      fsType = "zfs";
    };
    "/nix" = {
      device = "tank/nix";
      fsType = "zfs";
    };
    "/var" = {
      device = "tank/var";
      fsType = "zfs";
    };
    "/var/lib/secrets" = {
      device = "tank/secrets";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/var/lib/docker" = {
      device = "tank/docker";
      fsType = "zfs";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-label/SWAP";}
  ];

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      zfsSupport = true;
      configurationLimit = 20;
    };

    initrd.systemd.enable = true;
    initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "sd_mod"
      "sr_mod"
    ];

    kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };

    supportedFilesystems = ["zfs" "ext4"];
    zfs.enableUnstable = true;

    tmpOnTmpfs = true;

    initrd.postDeviceCommands = lib.mkAfter ''
      zfs rollback -r tank/footfs@empty
    '';
  };
}
