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

    nodes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "bunky"
        "pyxis"
        "ceylon"
      ];
    };
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
            ${
            lib.concatMapStringsSep "\n" (node: ''
              nameserver ${node} ${node}:8600
            '')
            cfg.nodes
          }
            accepted_payload_size 8192
            hold valid 5s

          frontend public
            bind 0.0.0.0:80
            bind [::]:80
            ${
            if cfg.ssl.enable
            then ''
              # require SSL for all requests using the wildcard certificate
                bind 0.0.0.0:443 ssl crt /var/lib/acme/rubek.cloud/full.pem
                bind [::]:443 ssl crt /var/lib/acme/rubek.cloud/full.pem
                http-request redirect scheme https code 301 unless { ssl_fc }
            ''
            else ""
          }

            acl path_known path_beg /.well-known .matrix/.well-known
            use_backend well-known if path_known

            acl host_matrix hdr(host) -i matrix.rubek.cloud
            acl path_matrix path_beg /_matrix
            use_backend matrix if host_matrix or path_matrix

            acl host_nix_cache hdr(host) -i nix-cache.rubek.cloud
            use_backend nix-cache if host_nix_cache

            acl host_github_app hdr(host) -i github-builder.rubek.cloud
            use_backend github-app if host_github_app

            acl host_lockpad hdr(host) -i lockpad.rubek.cloud
            use_backend lockpad if host_lockpad

            # all other requests go to the main backend
            default_backend app

          frontend stats
            bind *:1936
            stats enable
            stats uri /stats
            stats refresh 10s
            stats admin if LOCALHOST

          backend app
            balance roundrobin
            server-template rubek-dev-site 1-3 _rubek-dev-site._tcp.service.consul resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4 check

          backend well-known
            acl path_matrix_server path_beg /.well-known/matrix/server
            http-request return status 200 content-type application/json string '{ "m.server": "matrix.rubek.cloud:443" }' if path_matrix_server

            acl path_matrix_client path_beg /.well-known/matrix/client
            http-request return status 200 content-type application/json string '{ "m.homeserver": { "base_url": "https://matrix.rubek.cloud" } }' if path_matrix_client

          backend matrix
            balance roundrobin
            server-template matrix-conduit 1-3 _matrix-conduit._tcp.service.consul resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4 check

          backend github-app
            balance roundrobin
            server-template github-app 1-3 _flake-builder-github-app._tcp.service.consul resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4 check

          backend nix-cache
            balance roundrobin
            server-template nix-cache 1-3 _nix-cache._tcp.service.consul resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4 check

          backend lockpad
            balance roundrobin
            server-template lockpad 1-3 _lockpad._tcp.service.consul resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4 check
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
        defaults = {
          email = "justintrubek@protonmail.com";

          reloadServices = [
            "haproxy.service"
          ];
        };
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
