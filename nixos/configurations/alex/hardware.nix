{
  config,
  lib,
  modulesPath,
  self,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  justinrubek = {
    filesystem.zfs.enable = true;

    cloudhost.hetzner = {
      enable = true;
    };
  };

  fileSystems = {
    "/var/nfs" = {
      device = "persist/data";
      fsType = "zfs";
      # options = [ "noatime" "compression=lz4" ];
    };
  };

  services.nfs.server = {
    enable = true;
    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;
    exports = ''
      /var/nfs/ *(rw,fsid=0,subtree_check,async,no_root_squash,crossmnt)
    '';
  };

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = let
    ports = [
      # NFS
      111
      2049
      4000
      4001
      4002
      20048
      # minio
      9000
      9001
    ];
  in {
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };

  swapDevices = [
    {device = "/dev/disk/by-label/SWAP";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  # powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
