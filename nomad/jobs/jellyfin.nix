_: {
  job.jellyfin = {
    datacenters = [ "dc1" ];

    group.jellyfin = {
      count = 1;

      volume = {
        "jellyfin_cache" = {
          type = "csi";
          source = "jellyfin_cache";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };

        "jellyfin_config" = {
          type = "csi";
          source = "jellyfin_config";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };

        "jellyfin_media" = {
          type = "csi";
          source = "jellyfin_media";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };
      };

      networks = [
        {
          mode = "bridge";
          port.http.to = 8096;
        }
      ];

      task.jellyfin = {
        driver = "docker";

        volumeMounts = [
          {
            volume = "jellyfin_cache";
            destination = "/cache";
            readOnly = false;
          }
          {
            volume = "jellyfin_config";
            destination = "/config";
            readOnly = false;
          }
          {
            volume = "jellyfin_media";
            destination = "/media";
            readOnly = false;
          }
        ];

        config = {
          image = "jellyfin/jellyfin:latest";
          # image = "jellyfin/jellyfin@sha256:73501b70b0e884e5815d8f03d22973513ae7cadbcd8dba95da60e1d7c82dac7b";
        };

        resources = {
          cpu = 1024;
          memory = 1024;
        };
      };

      services = [
        {
          name = "jellyfin";
          port = "http";
          checks = [
            {
              type = "http";
              name = "jellyfin alive";
              path = "/web/index.html";
              interval = 20000000000;
              timeout = 5000000000;
            }
          ];
        }
      ];
    };
  };
}
