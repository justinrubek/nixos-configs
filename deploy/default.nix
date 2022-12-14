{
  self,
  inputs,
  config,
  ...
}: let
in {
  flake.deploy = {
    nodes = {
      bunky = {
        hostname = "5.78.53.16";
        profiles.system = {
          sshUser = "admin";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.bunky;
          user = "root";
        };
        profiles.justin = {
          sshUser = "admin";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations."justin@bunky";
          user = "justin";
        };
      };
    };
  };
}
