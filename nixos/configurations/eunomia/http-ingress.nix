{
  self',
  pkgs,
  ...
}: let
  contentDir = "${mountPoint}/public";
  dial = "tcp!100.123.62.120!4500";
  group = user;
  mountPoint = "${serviceDir}/nas";
  package = self'.packages.cli;
  port = 3502;
  serviceDir = "/var/lib/http-ingress";
  user = "http-ingress";

  mountScript = pkgs.writeShellApplication {
    name = "http-ingress-mount";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.procps
    ];
    text = ''
      set -euo pipefail

      MOUNT_POINT="$1"
      SERVICE_USER="$2"

      mkdir -p "$MOUNT_POINT"
      chown "$SERVICE_USER:$SERVICE_USER" "$MOUNT_POINT"

      if ! timeout 30s /run/wrappers/bin/9fs mount -i '${dial}' "$MOUNT_POINT"; then
        echo "Failed to mount NAS after 30 seconds" >&2
        exit 1
      fi

      for i in {1..10}; do
        if [ -d "$MOUNT_POINT/public" ]; then
          echo "Found $MOUNT_POINT/public after $i attempts" >&2
          exit 0
        fi
        echo "Waiting for $MOUNT_POINT/public to appear (attempt $i/10)" >&2
        sleep $((i * i))
      done

      echo "ERROR: $MOUNT_POINT/public never appeared" >&2
      exit 1
    '';
  };

  serviceWrapper = pkgs.writeShellApplication {
    name = "http-ingress-wrapper";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.procps
      mountScript
      package
    ];
    text = ''
      set -euo pipefail

      echo "WRAPPER: Starting http-ingress service" >&2

      SERVICE_DIR="${serviceDir}"
      MOUNT_POINT="${mountPoint}"

      mkdir -p "$SERVICE_DIR"
      chown ${user}:${group} "$SERVICE_DIR"

      echo "WRAPPER: Mounting filesystem to $MOUNT_POINT" >&2
      if ! ${mountScript}/bin/http-ingress-mount "$MOUNT_POINT" "${user}"; then
        echo "WRAPPER: Mount failed with status $?" >&2
        exit 1
      fi

      echo "WRAPPER: Mount successful, starting service" >&2
      exec ${package}/bin/cli ingress serve-dir \
        --address 0.0.0.0:${toString port} \
        --directory "${contentDir}"
    '';
  };
in {
  networking.firewall.allowedTCPPorts = [
    port
  ];
  systemd = {
    services = {
      http-ingress = {
        after = [
          "network.target"
          "tailscaled.service"
        ];
        description = "http-ingress service";
        serviceConfig = {
          AmbientCapabilities = "CAP_NET_BIND_SERVICE CAP_SYS_ADMIN";
          BindReadOnlyPaths = [
            "/nix/store"
            "/run/wrappers/bin"
          ];
          CapabilityBoundingSet = "CAP_NET_BIND_SERVICE CAP_SYS_ADMIN";
          ExecStart = ["${serviceWrapper}/bin/http-ingress-wrapper"];
          Group = group;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectHome = true;
          ProtectSystem = "strict";
          ReadWritePaths = [serviceDir];
          Restart = "on-failure";
          RestartSec = "5";
          StandardError = "journal+console";
          StandardOutput = "journal+console";
          SuccessExitStatus = "0 143";
          TimeoutStartSec = "90";
          TimeoutStopSec = "30";
          Type = "exec";
          User = user;
          IPAddressAllow = [
            "10.0.0.1/32"
            "::1/128"
            "127.0.0.1/32"
          ];
        };
        wants = ["tailscaled.service"];
        wantedBy = ["multi-user.target"];
      };
    };
    tmpfiles.rules = [
      "d ${serviceDir} 0700 ${user} ${group} -"
    ];
  };
  users = {
    groups.${group} = {
      name = group;
    };
    users.${user} = {
      inherit group;
      isSystemUser = true;
      description = "http-ingress service";
    };
  };
}
