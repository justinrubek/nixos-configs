{...}: let
  annapurna-image = "ghcr.io/justinrubek/annapurna:5b4bd028db4f169069d6c4154c6ef3515f8982cb";

  envKey = "annapurna/env";
  envSecret = name: ''{{ with secret "kv-v2/data/${envKey}" }}{{ .Data.data.${name} | toJSON }}{{ end }}'';
in {
  job.annapurna = {
    datacenters = ["dc1"];

    group.annapurna = {
      count = 1;
      networks = [
        {
          mode = "bridge";
          port.http.to = 5000;
        }
      ];

      task.backend = {
        driver = "docker";

        config = {
          image = annapurna-image;

          ports = ["http"];
          command = "annapurna-cli";
          args = [
            "server"
            "http"
          ];
        };

        vault = {
          policies = ["annapurna"];
        };

        templates = [
          {
            data = ''
              ANNAPURNA_AUTH_APP_ID=${envSecret "app_id"}
              ANNAPURNA_AUTH_URL=${envSecret "auth_url"}
              ANNAPURNA_FACTS_PATH=/facts
              ANNAPURNA_STATIC_PATH=/public
            '';
            destination = "secrets/env";
            env = true;
          }
        ];
      };

      services = [
        {
          name = "annapurna";
          port = "http";
          checks = [
            {
              type = "http";
              name = "annapurna-health";
              path = "/health";
              interval = 20000000000;
              timeout = 5000000000;
            }
          ];
        }
      ];
    };
  };
}
