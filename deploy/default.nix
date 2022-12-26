{
  self,
  inputs,
  config,
  ...
}: let
  mkDeployNode = {
    hostname,
    address ? hostname,
  }: {
    hostname = address;
    profiles.system = {
      sshUser = "admin";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${hostname};
      user = "root";
    };
    profiles.justin = {
      sshUser = "admin";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations."justin@${hostname}";
      user = "justin";
    };
  };
in {
  flake.deploy = {
    nodes = {
      bunky = mkDeployNode {hostname = "bunky";};
      pyxis = mkDeployNode {hostname = "pyxis";};
      ceylon = mkDeployNode {hostname = "ceylon";};
      huginn = mkDeployNode {hostname = "huginn";};
      alex = mkDeployNode {hostname = "alex";};
    };
  };
}
