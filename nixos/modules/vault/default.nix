{ self, ... }:
{
  config,
  pkgs,
  lib,
  flakeRootPath,
  ...
}:
let
  cfg = config.justinrubek.vault;
in
{
  options.justinrubek.vault = {
    enable = lib.mkEnableOption "configure vault";

    node_id = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "The node id of the this vault instance.";
    };

    retry_join = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "The list of nodes to join.";
    };

    include_package = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to include the vault package in the system.";
    };
  };

  config =
    let
      retry_join = lib.concatStringsSep "\n" (
        lib.lists.forEach cfg.retry_join (value: ''
          retry_join {
            leader_api_addr = "${value}"
          }
        '')
      );

      inherit (config.networking) hostName;
    in
    lib.mkIf cfg.enable {
      services.vault = {
        enable = true;

        address = "0.0.0.0:8200";

        storageBackend = "raft";
        storagePath = "/var/lib/vault";
        storageConfig = ''
          node_id = "${cfg.node_id}"
          ${retry_join}
        '';

        extraConfig = ''
          api_addr = "http://${hostName}:8200"
          cluster_addr = "http://${hostName}:8201"
          ui = true
          disable_mlock = true

          service_registration "consul" {
            address = "127.0.0.1:8500"
          }
        '';

        # TODO: use regular vault package after 1.12.3 is released
        # https://github.com/hashicorp/vault/issues/17527
        package = self.packages.${pkgs.system}.vault-bin;
      };

      networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
        allowedTCPPorts = [
          8200
          8201
        ];
      };

      environment.systemPackages = lib.mkIf cfg.include_package [ pkgs.vault ];
    };
}
