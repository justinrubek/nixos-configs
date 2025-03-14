{
  config,
  lib,
  inputs',
  pkgs,
  ...
}:
with lib; let
  cfg = config.justinrubek.services.vintagestory;

  package = pkgs.vintagestory;
  dataDir = "/opt/vintagestory/data";
in {
  options = {
    justinrubek.services.vintagestory = {
      enable = mkEnableOption (lib.mdDoc "vintagestory server");
    };
  };

  config = mkIf cfg.enable {
    # TODO: make a wrapper https://github.com/NixOS/nixpkgs/issues/360384#issuecomment-2557412151
    nixpkgs.config.permittedInsecurePackages = [
      "dotnet-runtime-7.0.20"
    ];

    systemd.services.vintagestory = {
      description = "vintagestory game server";
      requires = ["network.target"];
      serviceConfig = {
        ExecStart = "${package}/bin/vintagestory-server --dataPath ${dataDir}";
        ReadWritePaths = [dataDir];
        User = "vintagestory";
        WorkingDirectory = dataDir;
      };
      wantedBy = ["multi-user.target"];
    };

    users = {
      groups."vintagestory" = {};
      users."vintagestory" = {
        group = "vintagestory";
        home = "/opt/vintagestory";
        shell = pkgs.zsh;
        isSystemUser = true;
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
  };
}
