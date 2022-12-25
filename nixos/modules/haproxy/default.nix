{self, ...}: {
  config,
  pkgs,
  lib,
  flakeRootPath,
  ...
}: let
  cfg = config.justinrubek.haproxy;
in {
  options.justinrubek.haproxy = {
    enable = lib.mkEnableOption "run haproxy";

    ssl.enable = lib.mkEnableOption "fetch SSL certificates";
  };

  config = let
    hostName = config.networking.hostName;

    tailscaleInterface = config.services.tailscale.interfaceName;
  in
    lib.mkIf cfg.enable {
      services.haproxy = {
        enable = true;

        config = ''
          global
            maxconn 256

          defaults
            mode http
            timeout connect 5000ms
            timeout client 50000ms
            timeout server 50000ms

          resolvers consul
            nameserver bunky bunky:8600
            nameserver pyxis pyxis:8600
            nameserver ceylon ceylon:8600
            accepted_payload_size 8192
            hold valid 5s

          frontend public
            bind 0.0.0.0:80
            ${
            if cfg.ssl.enable
            then ''
              bind 0.0.0.0:443 ssl crt /var/lib/acme/rubek.cloud/full.pem
              http-request redirect scheme https code 301 unless { ssl_fc }
            ''
            else ""
          }
            default_backend app

          frontend stats
            bind *:1936
            stats enable
            stats uri /stats
            stats refresh 10s
            stats admin if LOCALHOST

          backend app
            balance roundrobin
            server-template rubek-dev-site 1-10 _rubek-dev-site._tcp.service.consul resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4 check
        '';
      };

      networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
        allowedTCPPorts = [
          1936 # HAProxy stats
        ];
      };

      networking.firewall.allowedTCPPorts =
        [
          80 # HTTP
        ]
        ++ lib.optionals cfg.ssl.enable [
          443 # HTTPS
        ];

      sops.secrets."porkbun_api" = lib.mkIf cfg.ssl.enable {
        sopsFile = "${flakeRootPath}/secrets/porkbun/creds.yaml";
        owner = "acme";
      };

      security.acme = lib.mkIf cfg.ssl.enable {
        acceptTerms = true;
        defaults.email = "justintrubek@protonmail.com";
        certs = {
          "rubek.cloud" = {
            domain = "*.rubek.cloud";
            extraDomainNames = [
              "rubek.cloud"
              "*.rubek.dev"
              "rubek.dev"
            ];
            dnsProvider = "porkbun";
            credentialsFile = config.sops.secrets."porkbun_api".path;
            dnsPropagationCheck = false;
            group = "haproxy";
          };
        };
      };
    };
}
