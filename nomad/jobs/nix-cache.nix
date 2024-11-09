_: let
  atticSecret = name: ''{{ with secret "kv-v2/data/nix-cache/attic" }}{{ .Data.data.${name} }}{{ end }}'';
  storageSecret = name: ''{{ with secret "kv-v2/data/nix-cache/object-storage" }}{{ .Data.data.${name} }}{{ end }}'';
  postgresSecret = name: ''{{ with secret "kv-v2/data/nix-cache/postgres" }}{{ .Data.data.${name} }}{{ end }}'';

  postgresUrl = ''postgres://${postgresSecret "username"}:${postgresSecret "password"}@alex:5435/${postgresSecret "database"}'';
in {
  job.nix_cache = {
    datacenters = ["dc1"];

    group.cache = {
      count = 1;

      networks = [
        {
          port.http.to = 8080;
        }
      ];

      task.server = {
        driver = "docker";

        config = {
          image = "ghcr.io/zhaofengli/attic:e5c8d2d50981a34602358d917e7be011b2c397a8";

          args = [
            "--config"
            "secrets/attic.toml"
          ];

          ports = ["http"];
        };

        vault = {
          policies = ["nix-cache-attic"];
        };

        templates = [
          {
            changeMode = "restart";
            destination = "secrets/attic.toml";
            data = ''
              listen = "[::]:8080"
              allowed-hosts = []
              api-endpoint = "https://nix-cache.rubek.cloud/"
              require-proof-of-possession = false

              [jwt.signing]
              token-hs256-secret-base64 = '${atticSecret "token_secret"}'

              [database]
              url = '${postgresUrl}'

              [storage]
              type = "s3"
              region = '${storageSecret "region"}'
              bucket = '${storageSecret "bucket"}'
              endpoint = '${storageSecret "endpoint"}'

              [storage.credentials]
              access_key_id = '${storageSecret "access_key"}'
              secret_access_key = '${storageSecret "secret_key"}'

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
          cpu = 1500;
          memory = 1600;
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
