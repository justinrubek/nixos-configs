{...}: let
  lockpad-image = "docker.io/justinrubek/lockpad@sha256:5e6c952203247f3f47a07379449bdf8abab0bb9348fe9914749e1186cf7ff9ab";
  postgres_image = "docker.io/justinrubek/postgres@sha256:d00c2e7a63d66d74188bfa3351870de5197a3442d53a155db6182a561387924a";

  envKey = "lockpad/env";
  envSecret = name: ''{{ with secret "kv-v2/data/${envKey}" }}{{ .Data.data.${name} | toJSON }}{{ end }}'';

  postgresKey = "lockpad/postgres";
  postgresSecret = name: ''{{ with secret "kv-v2/data/${postgresKey}" }}{{ .Data.data.${name} }}{{ end }}'';
  # postgresUrl = ''postgres://${postgresSecret "username"}:${postgresSecret "password"}@localhost:5435/${postgresSecret "database"}'';
  postgresUrl = ''postgres://${postgresSecret "username"}:${postgresSecret "password"}@localhost:5435/postgres'';
in {
  job.lockpad = {
    datacenters = ["dc1"];

    group.lockpad = {
      count = 1;

      volume = {
        "lockpad_postgres" = {
          type = "csi";
          source = "lockpad_postgres";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };
      };

      networks = [
        {
          mode = "bridge";
          port.http.to = 5000;
          port.database.to = 5435;
        }
      ];

      task.database = {
        lifecycle = {
          hook = "prestart";
          sidecar = true;
        };

        driver = "docker";
        config = {
          image = postgres_image;

          ports = ["database"];
        };

        volumeMounts = [
          {
            volume = "lockpad_postgres";
            destination = "/data";
            readOnly = false;
          }
        ];

        vault = {
          policies = ["lockpad-postgres"];
        };

        templates = [
          {
            data = ''
              POSTGRES_DB=${postgresSecret "database"}
              POSTGRES_USER=postgres
              POSTGRES_PASSWORD=${postgresSecret "password"}
              PGUSER=postgres
              PGDATA=/data/postgres
            '';
            destination = "local/env";
            env = true;
          }
        ];
      };

      task.database_migration = {
        lifecycle = {
          hook = "prestart";
          sidecar = false;
        };

        driver = "docker";
        config = {
          image = lockpad-image;
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
          policies = ["lockpad-postgres"];
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
          image = lockpad-image;

          ports = ["http"];
          command = "lockpad-cli";
          args = [
            "server"
            "http"
          ];
        };

        vault = {
          policies = ["lockpad" "lockpad-postgres"];
        };

        templates = [
          {
            data = ''
              LOCKPAD_SECRET_KEY=${envSecret "secret_key"}
              LOCKPAD_PUBLIC_KEY=${envSecret "public_key"}
              LOCKPAD_POSTGRES_URL=${postgresUrl}
            '';
            destination = "secrets/env";
            env = true;
          }
        ];
      };

      services = [
        {
          name = "lockpad";
          port = "http";
          checks = [
            {
              type = "http";
              name = "lockpad-health";
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