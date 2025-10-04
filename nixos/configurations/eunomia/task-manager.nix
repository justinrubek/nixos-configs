{
  config,
  pkgs,
  inputs',
  ...
}: let
  target = "tcp!nas!4500";
  homeDir = "/var/lib/rrythm";
  mnt = "${homeDir}/n/nas";
in {
  users = {
    groups."rrythm-group" = {};
    users."rrythm-user" = {
      isSystemUser = true;
      group = "rrythm-group";
      home = "/var/lib/rrythm";
      createHome = true;
    };
  };
  systemd = {
    services."rrythm" = {
      description = "Rrythm Service with Private Mounts";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStartPre = [
          "/run/wrappers/bin/9fs mount -i '${target}' '${mnt}'"
          "/run/wrappers/bin/9fs bind '${mnt}/data' '${homeDir}/data'"
        ];
        ExecStopPost = [
          "${pkgs.util-linux}/bin/umount /var/lib/rrythm/data || true"
          "${pkgs.util-linux}/bin/umount /var/lib/rrythm/mounts/9p || true"
        ];
        ExecStart = "${inputs'.rrythm.packages.default}/bin/rrythm";
        Group = "rrythm-group";
        PrivateMounts = true;
        Restart = "always";
        User = "rrythm-user";
        WorkingDirectory = "/var/lib/rrythm";
      };
    };
    tmpfiles.rules = [
      "d /var/lib/rrythm/mounts 0750 rrythm-user rrythm-group - -"
      "d /var/lib/rrythm/mounts/9p 0750 rrythm-user rrythm-group - -"
      "d /var/lib/rrythm/data 0750 rrythm-user rrythm-group - -"
    ];
  };
}
