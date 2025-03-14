{
  config,
  inputs,
  lib,
  self,
  ...
}: {
  perSystem = {
    config,
    pkgs,
    system,
    inputs',
    self',
    ...
  }: let
    hashicorp-pkgs = inputs.hashicorp_nixpkgs.legacyPackages.${system};
  in {
    devShells = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra
          pkgs.attic-client
          inputs.home-manager.packages.${system}.home-manager
          pkgs.nh
          hcloud
          hashicorp-pkgs.packer
          inputs'.deploy-rs.packages.deploy-rs

          pkgs.age
          pkgs.ssh-to-age
          pkgs.sops

          self'.packages.push-configuration
          inputs'.thoenix.packages.cli
          self'.packages.terraform

          self'.packages.vault-bin

          self'.packages.nomad

          pkgs.skopeo
          self'.packages."scripts/skopeo-push"

          inputs'.nix-postgres.packages."psql_15/bin"
        ];

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
  };
}
