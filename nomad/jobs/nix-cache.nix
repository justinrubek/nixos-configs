{...}: {
  job.nix_cache = {
    datacenters = ["dc1"];

    group.cache = {
      count = 1;

      volume = {
        "nix_cache_postgres" = {
          type = "csi";
          source = "nix_cache_postgres";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };
      };

      networks = [
        {
          mode = "bridge";
          port.http.to = 8080;
          port.database.to = 5432;
        }
      ];

      task.database = {
        driver = "docker";

        config = {
          image = "docker.io/postgres@sha256:2e89ed90224245851ea2b01e0b20c4b893e69141eb36e7a1cece7fb9e19f21f0";

          ports = ["database"];
        };

        volumeMounts = [
          {
            volume = "nix_cache_postgres";
            destination = "/var/lib/postgresql/data";
            readOnly = false;
          }
        ];

        vault = {
          policies = ["nix-cache-postgres"];
        };

        templates = [
          {
            data = let
              secretKey = "nix-cache/postgres";
              envSecret = name: ''{{ with secret "kv-v2/data/${secretKey}" }}{{ .Data.data.${name} }}{{ end }}'';
            in ''
              POSTGRES_USER=${envSecret "username"}
              POSTGRES_PASSWORD=${envSecret "password"}
            '';
            destination = "secrets/env";
            env = true;
          }
        ];
      };

      task.server = {
        driver = "docker";

        config = {
          image = "docker.io/justinrubek/attic@sha256:cd208158db0733791714d1c59d72a3710f4e67f7490ee0b770a786b3ca1b61ab";

          args = [
            "--config"
            "secrets/attic.toml"
          ];

          ports = ["http"];
        };

        vault = {
          policies = ["nix-cache-attic"];
        };

        templates = let
          databaseSecret = name: ''{{ with secret "kv-v2/data/nix-cache/database" }}{{ .Data.data.${name} }}{{ end }}'';
          minioSecret = name: ''{{ with secret "kv-v2/data/nix-cache/minio" }}{{ .Data.data.${name} }}{{ end }}'';

          postgresUrl = ''postgres://${databaseSecret "username"}:${databaseSecret "password"}@localhost:5432/${databaseSecret "database"}'';
        in [
          {
            changeMode = "restart";
            destination = "secrets/attic.toml";
            data = ''
              listen = "[::]:8080"
              allowed-hosts = []
              api-endpoint = "https://nix-cache.rubek.cloud/"
              require-proof-of-possession = false
              token-hs256-secret-base64 = '${databaseSecret "token_secret"}'

              [database]
              url = '${postgresUrl}'

              [storage]
              type = "s3"
              region = "us-east-1"
              bucket = '${minioSecret "bucket"}'
              endpoint = "http://alex:9000"

              [storage.credentials]
              access_key_id = '${minioSecret "access_key"}'
              secret_access_key = '${minioSecret "secret_key"}'

              [chunking]
              nar-size-threshold = 65536
              min-size = 16384
              avg-size = 65536
              max-size = 262144

              [compression]
              type = "zstd"
            '';
          }
        ];

        resources = {
          cpu = 500;
          memory = 400;
        };
      };

      services = [
        {
          name = "nix-cache";
          port = "http";
          checks = [
          ];
        }
      ];
    };
  };
}
