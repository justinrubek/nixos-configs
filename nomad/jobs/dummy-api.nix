_: {
  job.dummy_api = {
    datacenters = ["dc1"];

    group.api = {
      count = 1;

      networks = [
        {
          port.http.to = 8000;
        }
      ];

      task.backend = {
        driver = "docker";

        config = {
          image = "justinrubek/axum-dummy-api:0.2.1";
          ports = ["http"];
        };
      };

      services = [
        {
          name = "dummy-api";
          port = "http";
          checks = [
            {
              type = "http";
              name = "dummy-api-health";
              path = "/health";
              interval = 20000000000;
              timeout = 5000000000;
            }
          ];
        }
      ];
    };
  };
}
