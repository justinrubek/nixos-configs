{...}: let
  annapurna-image = "ghcr.io/justinrubek/annapurna:e5e48732bf6c2c2ea4e8144a9a3b2bbce6905ba9";

  lockpadSecret = name: ''{{ with secret "kv-v2/data/annapurna/lockpad" }}{{ .Data.data.${name} | toJSON }}{{ end }}'';

  postgresKey = "annapurna/postgres";
  postgresSecret = name: ''{{ with secret "kv-v2/data/${postgresKey}" }}{{ .Data.data.${name} }}{{ end }}'';
  postgresUrl = ''postgres://${postgresSecret "username"}:${postgresSecret "password"}@alex:5435/${postgresSecret "database"}'';
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

      task.database_migration = {
        lifecycle = {
          hook = "prestart";
          sidecar = false;
        };

        driver = "docker";
        config = {
          image = annapurna-image;
          command = "sqlx";
          args = [
            "migrate"
            "run"
            "--source"
            "/migrations"
            "--connect-timeout"
            "120"
          ];
        };

        vault = {
          policies = ["annapurna-postgres"];
        };

        templates = [
          {
            data = ''
              DATABASE_URL=${postgresUrl}
            '';
            destination = "local/env";
            env = true;
          }
        ];
      };

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
          policies = ["annapurna" "annapurna-postgres"];
        };

        templates = [
          {
            data = ''
              ANNAPURNA_AUTH_APP_ID=${lockpadSecret "application_id"}
              ANNAPURNA_AUTH_URL=${lockpadSecret "url"}
              ANNAPURNA_FACTS_PATH=/facts
              ANNAPURNA_POSTGRES_URL=${postgresUrl}
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
