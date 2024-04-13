_: {
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
          # nix_flake_ref = "github:justinrubek/rubek.dev#packages.x86_64-linux.server_script";
          # nix_flake_sha = "sha256-g/zqA5+ac+4GgcQfKvR7QM5MTs9TDju4qsDeELFLCUg=";
          # entrypoint = ["bin/start_server"];
          image = "justinrubek/rubek.dev:0.4.1";

          ports = ["http"];

          # mount = [
          #   {
          #     type = "bind";
          #     source = "/nix/store";
          #     target = "/nix/store";
          #     readonly = true;
          #     bind_options = {
          #       propagation = "rshared";
          #     };
          #   }
          # ];
        };

        vault = {
          policies = ["calendar-client"];
        };

        templates = [
          {
            data = let
              secretKey = "calendar/rubek-site";
              envSecret = name: ''{{ with secret "kv-v2/data/${secretKey}" }}{{ .Data.data.${name} }}{{ end }}'';
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
