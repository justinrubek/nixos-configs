_: {
  job.vault-key-test = {
    datacenters = [ "dc1" ];

    type = "batch";

    group.command = {
      count = 1;

      task.server = {
        driver = "docker";

        config = {
          nix_flake_ref = "github:nixos/nixpkgs#legacyPackages.x86_64-linux.hello";
          nix_flake_sha = "sha256-2BbZN9OC+6KdEVMQnkLEnXi5f/XNGKAM37S2OBs8xeQ=";
          entrypoint = [ "bin/hello" ];
          args = [
            "-g"
            "hello \${MESSAGE}"
          ];

          mount = [
            {
              type = "bind";
              source = "/nix/store";
              target = "/nix/store";
              readonly = true;
              bind_options = {
                propagation = "rshared";
              };
            }
          ];
        };

        vault = {
          policies = [ "hello" ];
        };

        templates = [
          {
            data = ''
              MESSAGE="{{ with secret "kv-v2/data/hello" }}{{ .Data.data.foo }}{{ end }}"
            '';
            destination = "local/env";
            env = true;
          }
        ];
      };
    };
  };
}
