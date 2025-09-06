{
  config,
  lib,
  inputs',
  pkgs,
  ...
}:
with lib; let
  cfg = config.justinrubek.services.vintagestory;

  dataDir = "/opt/vintagestory/data";
  modDir = "${dataDir}/Mods";
  emptyModList = pkgs.writeText "vintagestory-mods.ron" "[\n]";
in {
  options = {
    justinrubek.services.vintagestory = {
      enable = mkEnableOption (lib.mdDoc "vintagestory server");
      package = mkOption {
        type = types.package;
        default = pkgs.vintagestory;
        description = "Package containing the mod management wrapper binary";
      };
      wrapperPackage = mkOption {
        type = types.package;
        description = "Package containing the mod management wrapper binary";
      };
      modList = mkOption {
        type = types.path;
        default = emptyModList;
        description = "Path to the mod list file (RON format)";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.vintagestory = {
      description = "vintagestory game server with mod management";
      requires = ["network.target"];
      after = ["network.target"];
      serviceConfig = {
        ExecStart = ''
          ${cfg.wrapperPackage}/bin/factorio-server \
            server start \
            --executable ${cfg.package}/bin/vintagestory-server \
            --mod-directory ${modDir} \
            --mod-list ${cfg.modList} \
            -- --dataPath ${dataDir}
        '';
        ReadWritePaths = [
          dataDir
          modDir
        ];
        User = "vintagestory";
        Group = "vintagestory";
        # WorkingDirectory = dataDir;
        WorkingDirectory = "${cfg.package}/bin";
        Restart = "on-failure";
        RestartSec = "5";
      };
      wantedBy = ["multi-user.target"];
    };

    users = {
      groups."vintagestory" = {};
      users."vintagestory" = {
        group = "vintagestory";
        home = "/opt/vintagestory";
        shell = pkgs.fish;
        isSystemUser = true;
        createHome = true;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        42420 # vintagestory
      ];
      allowedUDPPorts = [
        42420 # vintagestory
      ];
    };

    # Ensure required directories exist
    systemd.tmpfiles.rules = [
      "d '${modDir}' 0750 vintagestory vintagestory - -"
      "f '${cfg.modList}' 0644 vintagestory vintagestory - '[]'"
    ];
  };
}
