{...}: {
  job.rubek_site = {
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
          nix_flake_ref = "github:justinrubek/rubek.dev#packages.x86_64-linux.server_script";
          nix_flake_sha = "sha256-tzBfT3LhL3WT2lTgDphCfNXCgqFLOm5BrrYL/IA1bG8=";
          entrypoint = ["bin/start_server"];

          ports = ["http"];

          mount = [
            {
              type = "bind";
              source = "/nix/store";
              target = "/nix/store";
              readonly = true;
              bind_options = {
                propagation = "rshared";
              };
            }
          ];
        };
      };

      services = [
        {
          name = "rubek-dev-site";
          port = "http";
          checks = [
            {
              type = "http";
              name = "rubek-dev-health";
              path = "/health";
              interval = 20000000000;
              timeout = 5000000000;
            }
          ];
        }
      ];

      update = {
        canary = 1;
        autoRevert = true;
        autoPromote = true;
      };
    };
  };
}
