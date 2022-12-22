{self, ...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.consul;
in {
  options.justinrubek.consul = {
    enable = lib.mkEnableOption "run consul";

    node_name = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "The name of the node";
    };
  };

  config = let
    hostName = config.networking.hostName;
  in
    lib.mkIf cfg.enable {
      services.consul = {
        enable = true;

        interface.bind = config.services.tailscale.interfaceName;

        webUi = true;
        extraConfig = {
          datacenter = "dc1";
          node_name = cfg.node_name;

          # bind_addr = "0.0.0.0";
          client_addr = "0.0.0.0";

          server = true;
          bootstrap_expect = 3;
        };
      };

      networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
        allowedTCPPorts = [
          8600 # Consul DNS
          8500 # Consul HTTP
          8501 # Consul HTTPS
          8502 # Consul gRPC
          8301 # Consul Serf (LAN)
          8302 # Consul Serf (WAN)
          8300 # Consul server
        ];

        allowedUDPPorts = [
          8600
          8301
          8302
        ];

        # sidecar proxy
        allowedTCPPortRanges = [
          {
            from = 21000;
            to = 21255;
          }
        ];
      };

      environment.systemPackages = [pkgs.consul];
    };
}
