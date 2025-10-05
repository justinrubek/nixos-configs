{
  config,
  lib,
  pkgs,
  self',
  ...
}: let
  group = user;
  runDir = "/run/http-proxy";
  package = self'.packages.cli;
  upgradeSocket = "${runDir}/upgrade.sock";
  user = "http-proxy";
in {
  systemd = {
    services = {
      http-proxy = {
        after = ["network.target"];
        description = "http-proxy";
        serviceConfig = {
          CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
          ExecReload = [
            "kill -SIGQUIT $MAINPID"
            "${package}/bin/cli http-proxy run --upgrade-socket=${upgradeSocket}"
          ];
          ExecStart = "${package}/bin/cli http-proxy run --upgrade-socket=${upgradeSocket}";
          Group = group;
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectHome = true;
          ProtectSystem = "strict";
          Restart = "on-failure";
          RestartSec = "5";
          RestrictSUIDSGID = true;
          TimeoutStartSec = "10";
          TimeoutStopSec = "31";
          Type = "exec";
          User = user;
        };
        wantedBy = ["multi-user.target"];
      };
    };
    tmpfiles.rules = [
      "d ${runDir} 0750 ${user} ${group} -"
      "z ${upgradeSocket} 0660 ${user} ${group} -"
    ];
  };
  users = {
    groups.${group} = {
      name = group;
    };
    users.${user} = {
      inherit group;
      isSystemUser = true;
      description = "http-proxy service";
    };
  };
}
