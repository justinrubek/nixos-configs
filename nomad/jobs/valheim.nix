{...}: {
  job.valheim = {
    datacenters = ["dc1"];

    group.valheim = {
      count = 1;

      volume = {
        "valheim_data" = {
          type = "csi";
          source = "valheim_data";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };

        "valheim_config" = {
          type = "csi";
          source = "valheim_config";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };
      };

      networks = [
        {
          mode = "bridge";
          port.game1.to = 2456;
          port.game2.to = 2457;
          port.supervisor.to = 9001;
        }
      ];

      task.valheim-server = {
        driver = "docker";

        env = {
          SERVER_NAME = "Valheim Server";
          WORLD_NAME = "testworld";
          SERVER_PASSWORD = "password";
        };

        volumeMounts = [
          {
            volume = "valheim_data";
            destination = "/opt/valheim";
            readOnly = false;
          }
          {
            volume = "valheim_config";
            destination = "/config";
            readOnly = false;
          }
        ];

        config = {
          image = "ghcr.io/lloesche/valheim-server";
        };

        resources = {
          cpu = 6000;
          memory = 4096;
        };
      };

      services = [
        {
          name = "valheim-game";
          port = "game1";
        }
      ];
    };
  };
}
