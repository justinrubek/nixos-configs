_: {
  job.flake_builder = {
    datacenters = [ "dc1" ];

    group.api = {
      count = 1;

      networks = [ { port.http.to = 3000; } ];

      task.backend = {
        driver = "docker";

        config = {
          # image = "justinrubek/flake-builder:69c2cbe5d0c3d7cafb7f0e67355d84ad1f98cbdf";
          image = "justinrubek/flake-builder:latest";

          ports = [ "http" ];

          command = "flake-builder-cli";
          args = [
            "server"
            "http"
          ];

          volumes = [ "local/nix.conf:/etc/nix/nix.conf" ];
        };

        templates = [
          {
            destination = "local/nix.conf";
            data = ''
              experimental-features = nix-command flakes
              build-users-group =
            '';
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
