{...}: {
  job.paperless = {
    datacenters = ["dc1"];

    group.paperless = {
      count = 1;

      volume = {
        "paperless_consume" = {
          type = "csi";
          source = "paperless_consume";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };
        "paperless_data" = {
          type = "csi";
          source = "paperless_data";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };
        "paperless_media" = {
          type = "csi";
          source = "paperless_media";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };
      };

      networks = [
        {
          mode = "bridge";
          port.http.to = 8000;
          port.redis.to = 6379;
        }
      ];

      task.redis = {
        driver = "docker";

        config = {
          image = "redis:6";
          ports = ["redis"];
        };

        resources = {
          cpu = 20;
          memory = 128;
        };

        lifecycle = {
          hook = "prestart";
          sidecar = true;
        };
      };

      task.paperless = {
        driver = "docker";

        config = {
          image = "justinrubek/paperless:latest";
          entrypoint = ["/sbin/docker-entrypoint.sh"];
          command = "/usr/local/bin/paperless_cmd.sh";
          work_dir = "/usr/src/paperless/src";
          # image = "paperlessngx/paperless-ngx:latest";
          ports = ["http"];
        };

        volumeMounts = [
          {
            volume = "paperless_consume";
            destination = "/usr/src/paperless/consume";
            readOnly = false;
          }
          {
            volume = "paperless_data";
            destination = "/usr/src/paperless/data";
            readOnly = false;
          }
          {
            volume = "paperless_media";
            destination = "/usr/src/paperless/media";
            readOnly = false;
          }
        ];

        resources = {
          cpu = 500;
          memory = 1000;
        };

        env = {
          USERMAP_UID = "1000";
          USERMAP_GID = "1000";
          PAPERLESS_TIME_ZONE = "America/Chicago";
          PAPERLESS_REDIS = "redis://localhost:6379";

          PAPERLESS_SECRET_KEY = "REDACTED";
          PAPERLESS_OCR_LANGUAGES = "eng";

          PAPERLESS_ADMIN_USER = "admin";
          PAPERLESS_ADMIN_PASSWORD = "REDACTED";
        };
      };

      services = [
        {
          name = "paperless";
          port = "http";
          checks = [
            {
              type = "http";
              name = "paperless alive";
              path = "/";
              interval = 20000000000;
              timeout = 5000000000;
            }
          ];
        }
      ];
    };
  };
}
