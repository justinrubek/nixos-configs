{
  config,
  lib,
  ...
}: let
  cfg = config.justinrubek.services.navidrome;

  setupMounts = mounts: let
    mountCommands =
      lib.mapAttrsToList (
        mountPoint: mountConfig: let
          dialString = mountConfig.dial;
          mountArgs =
            if mountConfig ? args
            then " ${mountConfig.args}"
            else "";
        in "/run/wrappers/bin/9fs mount -i '${dialString}' ${mountPoint}${mountArgs}"
      )
      mounts;

    unmountCommands =
      lib.mapAttrsToList (
        mountPoint: _: "/run/wrappers/bin/9fs umount ${mountPoint}"
      )
      mounts;
  in {
    setup = mountCommands;
    teardown = unmountCommands;
  };

  svcMounts = setupMounts {
    "/var/lib/navidrome/n/nas" = {
      dial = "tcp!nas!4501";
    };
  };
in {
  options.justinrubek.services.navidrome = {
    enable = lib.mkEnableOption "run media";
  };

  config = lib.mkIf cfg.enable {
    services = {
      navidrome = {
        enable = true;
        settings = {
          Address = "0.0.0.0";
          DataFolder = "/var/lib/navidrome/n/nas/svc/navidrome/data";
          MusicFolder = "/var/lib/navidrome/n/nas/music";
          Port = 8114;
        };
      };
    };

    networking.firewall.interfaces.${config.services.tailscale.interfaceName} = let
      ports = {
        navidrome = [config.services.navidrome.settings.Port];
      };

      allPorts = lib.flatten (lib.attrValues ports);
    in {
      allowedTCPPorts = allPorts;
      allowedUDPPorts = allPorts;
    };

    systemd.services.navidrome-mount = {
      after = ["network-online.target"];
      before = ["navidrome.service"];
      description = "Mount 9p for Navidrome";
      wants = ["network-online.target"];
      wantedBy = ["navidrome.service" "multi-user.target"];
      path = ["/run/wrappers"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        User = "navidrome";
        Group = "navidrome";

        ExecStart = lib.head svcMounts.setup;
        # ExecStop = lib.head svcMounts.teardown;
      };
    };

    systemd.services.navidrome = {
      requires = ["navidrome-mount.service"];
      after = ["navidrome-mount.service"];

      serviceConfig = {
        BindPaths = [
          "/var/lib/navidrome:/var/lib/navidrome"
          "/var/lib/navidrome/cache:/var/lib/navidrome/cache"
          "/var/lib/navidrome/data:/var/lib/navidrome/data"
          "/var/lib/navidrome/n/nas:/var/lib/navidrome/n/nas"
        ];
        ReadWritePaths = [
          "/var/lib/navidrome"
          "/var/lib/navidrome/cache"
          "/var/lib/navidrome/data"
          "/var/lib/navidrome/n/nas/svc/navidrome/data"
        ];
        # TODO: figure out which of these are needed, which are not, and what other things are missing
        # Disable ALL namespace and mount-related isolation
        PrivateNetwork = lib.mkForce false;
        PrivateTmp = lib.mkForce false;
        PrivateDevices = lib.mkForce false;
        PrivateIPC = lib.mkForce false;
        PrivateUsers = lib.mkForce false;
        ProtectHostname = lib.mkForce false;
        ProtectClock = lib.mkForce false;
        ProtectKernelTunables = lib.mkForce false;
        ProtectKernelModules = lib.mkForce false;
        ProtectKernelLogs = lib.mkForce false;
        ProtectControlGroups = lib.mkForce false;
        ProtectSystem = lib.mkForce false;
        ProtectHome = lib.mkForce false;
        ProtectProc = lib.mkForce "noaccess";
        ProcSubset = lib.mkForce "all";

        # Also disable other security features that might interfere
        MemoryDenyWriteExecute = lib.mkForce false;
        LockPersonality = lib.mkForce false;
        RestrictRealtime = lib.mkForce false;
        RestrictAddressFamilies = lib.mkForce [];
        SystemCallFilter = lib.mkForce [];
        SystemCallArchitectures = lib.mkForce "native";

        # Explicitly disable namespace features
        PrivateMounts = lib.mkForce false;
        MountAPIVFS = lib.mkForce false;
        RootDirectory = lib.mkForce null;
        RestrictNamespaces = lib.mkForce false;
      };
    };
  };
}
