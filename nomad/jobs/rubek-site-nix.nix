{...}: {
  job.rubek_site_nix = {
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
          nix_flake_ref = "github:justinrubek/rubek.dev#packages.x86_64-linux.server/script";
          nix_flake_sha = "sha256-hAX/bmafN+Yn0n6y1lGGQOfkNfIHrb7g8IBJqcoT/y8=";
          entrypoint = ["bin/start_server"];
          # image = "justinrubek/rubek.dev:0.1.5";

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

        vault = {
          policies = ["calendar-client"];
        };

        templates = [
          {
            data = let
              envSecret = name: ''{{ with secret "kv-v2/data/calendar/rubek-site" }}{{ .Data.data.${name} }}{{ end }}'';
            in ''
              CALDAV_USERNAME=${envSecret "username"}
              CALDAV_PASSWORD=${envSecret "password"}
              CALDAV_URL=${envSecret "url"}
              AVAILABLE_CALENDAR=${envSecret "available_calendar"}
              BOOKED_CALENDAR=${envSecret "booked_calendar"}
            '';
            destination = "secrets/env";
            env = true;
          }
        ];
      };

      services = [
        {
          name = "rubek-dev-site-nix";
          port = "http";
          checks = [
            {
              type = "http";
              name = "rubek-dev-nix-health";
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
