{self, ...}: {
  config,
  pkgs,
  lib,
  flakeRootPath,
  ...
}: let
  cfg = config.justinrubek.nomad;
in {
  options.justinrubek.nomad = {
    enable = lib.mkEnableOption "run nomad";
  };

  config = let
    hostName = config.networking.hostName;

    tailscaleInterface = config.services.tailscale.interfaceName;
  in
    lib.mkIf cfg.enable {
      services.nomad = {
        enable = true;
        enableDocker = true;

        # required in order to access nix for pulling images with docker driver mods
        dropPrivileges = false;

        # use patched nomad for flake support
        package = self.packages.${pkgs.system}.nomad;

        extraPackages = [config.nix.package];

        settings = {
          bind_addr = "0.0.0.0";
          # bind_addr = ''{{ GetInterfaceIP "${tailscaleInterface}" }}'';
          datacenter = "dc1";

          advertise = let
            address = "{{ GetInterfaceIP \"${tailscaleInterface}\" }}";
          in {
            http = address;
            rpc = address;
            serf = address;
          };

          server = {
            enabled = true;
            bootstrap_expect = 3;
          };

          client = {
            enabled = true;
            network_interface = config.services.tailscale.interfaceName;
            # network_interface = "{{ GetAllInterfaces }}";
            cni_path = "${pkgs.cni-plugins}/bin";

            options = {
              "docker.privileged.enabled" = "true";
            };
          };

          vault = {
            enabled = true;
            address = "http://127.0.0.1:8200";
            create_from_role = "nomad-cluster";
          };
        };
      };

      # ensure that docker is present
      justinrubek.development.containers = {
        enable = true;
        useDocker = true;
      };

      sops.secrets.nomad_env = {
        sopsFile = "${flakeRootPath}/secrets/nomad.yaml";
        owner = config.systemd.services.serviceConfig.User or "root";
        restartUnits = ["nomad.service"];
      };

      systemd.services.nomad = {
        serviceConfig = {
          EnvironmentFile = [config.sops.secrets."nomad_env".path];
        };
      };

      networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
        # nomad ports
        allowedTCPPorts = [4646 4647 4648];
        allowedUDPPorts = [4648];

        # ephemeral ports
        allowedTCPPortRanges = [
          {
            from = 20000;
            to = 32000;
          }
        ];
      };
    };
}
