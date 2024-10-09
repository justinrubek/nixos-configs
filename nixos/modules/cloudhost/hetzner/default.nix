{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.justinrubek.cloudhost.hetzner;
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

      initrd.systemd = {
        enable = true;
        # postDeviceCommands for systemd in stage-1
        services.rollback = {
          description = "Rollback to empty snapshot";
          wantedBy = ["initrd.target"];
          after = ["zfs-import.target"];
          before = ["sysroot.mount"];
          path = [pkgs.zfs];
          unitConfig.DefaultDependencies = "no";
          serviceConfig = {
            Type = "oneshot";
          };
          script = ''
            zfs rollback -r tank/footfs@empty
          '';
        };
      };
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
      zfs.package = pkgs.zfs_unstable;

      tmp.useTmpfs = true;
    };

    systemd.network = {
      enable = true;
      networks.default = {
        matchConfig.Name = "en*";
        networkConfig.DHCP = "yes";
      };
    };

    # services.resolved = {
    #   enable = true;
    #   extraConfig = ''
    #     nameserver 1.1.1.1
    #     nameserver 8.8.8.8
    #   '';
    # };

    networking = rec {
      useNetworkd = false;
      useDHCP = false;
    };
  };
}
