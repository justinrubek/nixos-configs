{...}: {
  job.conduit = {
    datacenters = ["dc1"];

    group.matrix = {
      count = 1;

      volume = {
        "conduit_data" = {
          type = "csi";
          source = "conduit_data";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };
      };

      networks = [
        {
          port.http.to = 6167;
        }
      ];

      task.backend = {
        driver = "docker";

        config = {
          image = "justinrubek/conduit:c56d3b54f32207644e5619123ffff93e79396bc7";

          ports = ["http"];

          volumes = [
            "local/conduit.toml:/etc/conduit.toml"
          ];
        };

        volumeMounts = [
          {
            volume = "conduit_data";
            destination = "/var/lib/matrix-conduit";
            readOnly = false;
          }
        ];

        vault = {
          policies = ["matrix-homeserver-conduit"];
        };

        env = {
          CONDUIT_CONFIG = "/etc/conduit.toml";
        };

        templates = [
          {
            data = ''
              [global]
              server_name = "rubek.cloud"

              database_path = "/var/lib/matrix-conduit/"
              database_backend = "rocksdb"

              port = 6167

              max_request_size = 20_000_000

              allow_registration = false
              allow_federation = true

              enable_lightning_bolt = true

              trusted_servers = ["matrix.org"]

              address = "0.0.0.0"
            '';
            destination = "local/conduit.toml";
          }
        ];
      };

      services = [
        {
          name = "matrix-conduit";
          port = "http";
          checks = [
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
