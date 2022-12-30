{...}: {
  job.vault-key-test = {
    datacenters = ["dc1"];

    type = "batch";

    group.command = {
      count = 1;

      task.server = {
        driver = "docker";

        config = {
          nix_flake_ref = "github:nixos/nixpkgs#legacyPackages.x86_64-linux.hello";
          nix_flake_sha = "sha256-o+TBFFNSdOu5L1CUetXGMSinghqqlWcI2Sj9GVoJmUY=";
          entrypoint = ["bin/hello"];

          args = ["-g" "hello world!"];

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
      };
    };
  };
}
