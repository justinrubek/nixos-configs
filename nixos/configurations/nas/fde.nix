{lib, ...}: let
  keyid = "9D3A-D083";
in {
  boot = {
    initrd = {
      kernelModules = [
        "uas"
        "usbcore"
        "usb_storage"
        "vfat"
        "nls_cp437"
        "nls_iso8859_1"
      ];
      postDeviceCommands = lib.mkBefore ''
        mkdir -m 0755 -p /key
        sleep 2 # make sure the usb key has been loaded
        mount -n -t vfat -o ro `findfs UUID=${keyid}` /key
      '';
    };
    supportedFilesystems = [
      "ext4"
      "btrfs"
    ];
  };
}
