{...}: {
  job.jellyfin = {
    datacenters = ["dc1"];

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
        }
      ];
    };
  };
}
