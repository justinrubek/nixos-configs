{...}: let
  annapurna-image = "ghcr.io/justinrubek/annapurna:2859867a08d75e3e1badfd1f0d3a82d71db4e354";

  lockpadSecret = name: ''{{ with secret "kv-v2/data/annapurna/lockpad" }}{{ .Data.data.${name} | toJSON }}{{ end }}'';
in {
  job.annapurna = {
    datacenters = ["dc1"];

    group.annapurna = {
      count = 1;

      networks = [
        {
          port.http.to = 3000;
        }
      ];

      task.backend = {
        driver = "docker";

        config = {
          image = annapurna-image;

          ports = ["http"];
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
              ANNAPURNA_AUTH_APP_ID=${lockpadSecret "application_id"}
              ANNAPURNA_AUTH_URL=${lockpadSecret "url"}
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
              path = "/api/health";
              interval = 20000000000;
              timeout = 5000000000;
            }
          ];
        }
      ];
    };
  };
}
