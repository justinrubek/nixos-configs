_: let 
  envSecret = name: ''{{ with secret "kv-v2/data/flake-builder/env" }}{{ .Data.data.${name} | toJSON }}{{ end }}'';
  githubSecret = name: ''{{ with secret "kv-v2/data/github/apps/flake-builder" }}{{ .Data.data.${name} | toJSON }}{{ end }}'';
  atticSecret = name: ''{{ with secret "kv-v2/data/flake-builder/attic" }}{{ .Data.data.${name} | toJSON }}{{ end }}'';
in {
  job.flake_builder = {
    datacenters = ["dc1"];

    group.api = {
      count = 1;

      networks = [
        {
          port.http.to = 3000;
        }
      ];

      task.backend = {
        driver = "docker";

        config = {
          image = "ghcr.io/justinrubek/flake-builder:18";

          ports = ["http"];

          command = "flake-builder";
          args = [
            "server"
            "http"
          ];

          volumes = [
            "local/nix.conf:/etc/nix/nix.conf"
          ];
        };

        vault = {
          policies = ["flake-builder-github"];
        };

        templates = [
          {
            destination = "local/nix.conf";
            data = ''
              experimental-features = nix-command flakes
              build-users-group =
            '';
          }
          {
            data = ''
              JWT_SIGNER_ISSUER=${githubSecret "client_id"}
              JWT_SIGNER_SECRET_KEY=${githubSecret "private_key"}
              FLAKE_BUILDER_GITHUB_APP_ID=${githubSecret "app_id"}
              FLAKE_BUILDER_GITHUB_APP_WEBHOOK_SECRET=${githubSecret "webhook_secret"}
              FLAKE_BUILDER_GITHUB_APP_PRIVATE_KEY=${githubSecret "private_key"}
              FLAKE_BUILDER_NIX_CACHE_IDENT=${atticSecret "ident"}
              FLAKE_BUILDER_NIX_CACHE_ENDPOINT=${atticSecret "endpoint"}
              FLAKE_BUILDER_NIX_CACHE_NAME=${atticSecret "name"}
              FLAKE_BUILDER_NIX_CACHE_TOKEN=${atticSecret "token"}
            '';
            destination = "secrets/env";
            env = true;
          }
        ];

        resources = {
          cpu = 3500;
          memory = 1500;
        };
      };

      services = [
        {
          name = "flake-builder-github-app";
          port = "http";
          # TODO: get healthchecks on the service
          # checks = [
          #   {
          #     type = "http";
          #     name = "dummy-api-health";
          #     path = "/health";
          #     interval = 20000000000;
          #     timeout = 5000000000;
          #   }
          # ];
        }
      ];
    };
  };
}
