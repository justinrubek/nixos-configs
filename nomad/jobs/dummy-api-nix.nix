{...}: {
  job.dummy_api_nix = {
    datacenters = ["dc1"];

    group.api = {
      count = 1;

      networks = [
        {
          port.http.to = 8000;
        }
      ];

      task.backend = {
        driver = "docker";

        config = {
          nix_flake_ref = "github:justinrubek/axum-dummy-api#packages.x86_64-linux.api";
          nix_flake_sha = "sha256-1q0j7qj7qj7qj7qj7qj7qj7qj7qj7qj7qj7qj7qj7qj7qj7qj7q";
          entrypoint = ["bin/dummy_api"];

          ports = ["http"];
        };
      };

      services = [
        {
          name = "dummy-api-nix";
          port = "http";
          checks = [
            {
              type = "http";
              name = "dummy-api-health";
              path = "/health";
              interval = 20000000000;
              timeout = 5000000000;
            }
          ];
        }
      ];

      mounts = [
        {
          type = "bind";
          source = "/nix/store";
          target = "/nix/store";
          readonly = true;
        }
      ];
    };
  };
}
