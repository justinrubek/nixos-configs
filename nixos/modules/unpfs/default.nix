{
  config,
  inputs',
  lib,
  ...
}: let
  cfg = config.services.unpfs;
in {
  options = {
    services.unpfs = {
      enable = lib.mkEnableOption "9p file server";

      dataDir = lib.mkOption {
        type = lib.types.path;
        description = ''the path to the data directory'';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.stowage = {};

    users.users.stowage = {
      home = cfg.dataDir;
      group = "stowage";
      description = "file storage";
      isSystemUser = true;
    };

    systemd.services.unpfs = {
      description = "file server";

      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target" "mnt-data.mount"];

      script = ''
        ${inputs'.unpfs.packages.cli}/bin/unpfs tcp!0.0.0.0!4500 /mnt/data
      '';

      serviceConfig = {
        User = "stowage";
        Group = "stowage";

        Type = "simple";
        Restart = "on-failure";
      };
    };
  };
}
