{...}: {
  job.postgres = {
    datacenters = ["dc1"];

    group.db = {
      count = 1;

      networks = [
        {
          port.db.to = 5432;
        }
      ];

      task.server = {
        driver = "docker";

        config = {
          image = "hashicorp/postgres-nomad-demo:latest";
          ports = ["db"];
        };
      };

      services = [
        {
          name = "postgres";
          port = "db";
          checks = [
            {
              type = "tcp";
              interval = 20000000000;
              timeout = 2000000000;
            }
          ];
        }
      ];
    };
  };
}
