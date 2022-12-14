{...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.filesystem.zfs;
in {
  options.justinrubek.filesystem.zfs = {
    enable = lib.mkEnableOption "enable zfs filesystem";
  };

  config = lib.mkIf cfg.enable {
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
  };
}
