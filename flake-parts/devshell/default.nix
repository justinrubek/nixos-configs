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
    pre-commit-check = import ./pre_commit.nix inputs system;
  in rec {
    devShells = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra
          inputs.home-manager.packages.${system}.home-manager
          hcloud
          packer
          inputs'.deploy-rs.packages.deploy-rs

          pkgs.age
          pkgs.ssh-to-age
          pkgs.sops

          self'.packages.terraform-command
          self'.packages.push-configuration

          self'.packages.vault-bin

          self'.packages.nomad

          pkgs.skopeo
          self'.packages."scripts/skopeo-push"
        ];
        inherit (pre-commit-check) shellHook;
      };
    };

    checks = {
      pre-commit = pre-commit-check;
    };
  };
}
