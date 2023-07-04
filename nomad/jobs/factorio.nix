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
          image = "docker.io/justinrubek/factorio-server:aa661c0eb49ad181e65fdd7529cc4dc791564e88";

          volumes = [
            "local/server-settings.json:/etc/server-settings.json"
            "local/factorio.conf:/etc/factorio.conf"
            "local/server-adminlist.json:/etc/server-adminlist.json"
            "local/mods.ron:/etc/mods.ron"
          ];

          # Run /bin/factorio with the following arguments
          # - the save to use `/opt/factorio/saves/new-save.zip`
          command = "factorio-server";
          args = [
            "server"
            "start"
            "--mod-directory"
            "/opt/factorio/mods"
            "--mod-list"
            "/etc/mods.ron"
            "--"
            "--config"
            "/etc/factorio.conf"
            # "--start-server"
            # "/opt/factorio/saves/keghan-fixtrains.zip"
            "--start-server-load-latest"
            "--server-settings"
            "/etc/server-settings.json"
            "--server-adminlist"
            "/etc/server-adminlist.json"
          ];
        };

        vault = {
          policies = ["factorio-server"];
        };

        templates = [
          {
            data = let
              envSecret = name: ''{{ with secret "kv-v2/data/factorio" }}{{ .Data.data.${name} }}{{ end }}'';
            in ''
              FACTORIO_USERNAME=${envSecret "username"}
              FACTORIO_TOKEN=${envSecret "token"}
            '';
            destination = "secrets/env";
            env = true;
          }
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
          {
            destination = "local/mods.ron";
            data = ''
              [
                  (name: "aai-containers", version: "0.2.11"),
                  (name: "aai-industry", version: "0.5.19"),
                  (name: "aai-signal-transmission", version: "0.4.7"),
                  (name: "alien-biomes", version: "0.6.8"),
                  (name: "flib", version: "0.12.4"),
                  (name: "FluidMustFlow", version: "1.3.1"),
                  (name: "FluidMustFlowSE", version: "0.0.1"),
                  (name: "FNEI", version: "0.4.1"),
                  (name: "grappling-gun", version: "0.3.3"),
                  (name: "helmod", version: "0.12.16"),
                  (name: "informatron", version: "0.3.2"),
                  (name: "jetpack", version: "0.3.13"),
                  (name: "Krastorio2", version: "1.3.21"),
                  (name: "Krastorio2Assets", version: "1.2.1"),
                  (name: "LogisticTrainNetwork", version: "1.18.3"),
                  (name: "Mechanicus", version: "1.0.7"),
                  (name: "miniloader", version: "1.15.6"),
                  (name: "RateCalculator", version: "2.4.6"),
                  // (name: "RateCalculator", version: "3.2.2"),
                  (name: "robot_attrition", version: "0.5.15"),
                  (name: "se-ltn-glue", version: "0.6.0"),
                  (name: "shield-projector", version: "0.1.6"),
                  (name: "simhelper", version: "1.1.4"),
                  (name: "space-exploration-graphics", version: "0.6.15"),
                  (name: "space-exploration-graphics-2", version: "0.6.1"),
                  (name: "space-exploration-graphics-3", version: "0.6.2"),
                  (name: "space-exploration-graphics-4", version: "0.6.2"),
                  (name: "space-exploration-graphics-5", version: "0.6.1"),
                  (name: "space-exploration-menu-simulations", version: "0.6.8"),
                  (name: "space-exploration-postprocess", version: "0.6.24"),
                  (name: "space-exploration", version: "0.6.101"),
                  (name: "Todo-List", version: "19.2.0"),
                  (name: "YARM", version: "0.8.207"),
                  (name: "cybersyn", version: "1.2.16"),
                  (name: "LogisticRequestManager", version: "1.1.29"),
                  (name: "missing-circuit", version: "0.1.5"),
              ]
            '';
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
