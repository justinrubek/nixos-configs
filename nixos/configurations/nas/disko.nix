let
  keyFile = "/etc/luks-key/storage.key";
in {
  disko.devices = {
    disk = {
      disk0 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            crypt_p0 = {
              size = "100%";
              content = {
                type = "luks";
                name = "p0";
                settings = {
                  allowDiscards = true;
                  inherit keyFile;
                };
              };
            };
          };
        };
      };
      disk1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            crypt_p2 = {
              size = "100%";
              content = {
                type = "luks";
                name = "p1";
                settings = {
                  allowDiscards = true;
                  inherit keyFile;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-d raid1"
                    "/dev/mapper/p0"
                  ];
                  subvolumes = {
                    "/data" = {
                      mountpoint = "/data";
                      mountOptions = [
                        "rw"
                        "relatime"
                        "ssd"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
