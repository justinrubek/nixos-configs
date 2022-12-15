inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.cloudhost.hetzner;

  # nixpkgs modules
  modulesPath = "${inputs.nixpkgs}/nixos/modules";
in {
  options.justinrubek.cloudhost.hetzner = {
    enable = lib.mkEnableOption "enable hetzner cloud modules";
  };

  config = lib.mkIf cfg.enable {
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

    systemd.network = {
      enable = true;
      networks.default = {
        matchConfig.Name = "en*";
        networkConfig.DHCP = "yes";
      };
    };

    networking = rec {
      useNetworkd = false;
      useDHCP = false;
    };
  };
}
