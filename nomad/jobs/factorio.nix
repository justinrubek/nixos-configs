{...}: {
  job.factorio = {
    datacenters = ["dc1"];

    group.factorio = {
      count = 1;

      volume = {
        "factorio_data" = {
          type = "csi";
          source = "factorio_data";
          readOnly = false;

          attachmentMode = "file-system";
          accessMode = "single-node-writer";
        };
      };

      networks = [
        {
          mode = "bridge";
          port.game.to = 34197;
          port.game.static = 34197;
        }
      ];

      task.factorio-server = {
        driver = "docker";

        env = {
        };

        volumeMounts = [
          {
            volume = "factorio_data";
            destination = "/opt/factorio";
            readOnly = false;
          }
        ];

        config = {
          image = "docker.io/justinrubek/factorio-server:c4aae5d13abfe240783b247f5c1647c9e7617755";

          volumes = [
            "local/server-settings.json:/etc/server-settings.json"
            "local/factorio.conf:/etc/factorio.conf"
          ];

          # Run /bin/factorio with the following arguments
          # - the save to use `/opt/factorio/saves/new-save.zip`
          command = "factorio";
          args = [
            "--config"
            "/etc/factorio.conf"
            "--start-server"
            "/opt/factorio/saves/keghan-fixtrains.zip"
            "--server-settings"
            "/etc/server-settings.json"
          ];
        };

        templates = [
          {
            destination = "local/server-settings.json";
            data = let
              server-settings = {
                name = "The Factory Must Grow.";
                description = "I used to have a family, but now I have a factory.";
                visibility.lan = true;

                autosave_interval = 1;
                autosave_slots = 10;
                non_blocking_saving = true;

                auto_pause = true;
              };
              json = builtins.toJSON server-settings;
            in
              json;
          }
          {
            destination = "local/factorio.conf";
            data = ''
              use-system-read-write-data-directories=true
              [path]
              read-data=/share/factorio/data
              write-data=/opt/factorio
            '';
          }
          {
            destination = "local/server-adminlist.json";
            data = let
              server-adminlist = [
                "justinkingr"
                "sinnyen"
              ];
              json = builtins.toJSON server-adminlist;
            in
              json;
          }
        ];

        resources = {
          cpu = 6000;
          memory = 4096 + 2048;
        };
      };

      services = [
        {
          name = "factorio-game";
          port = "game";
        }
      ];
    };
  };
}
