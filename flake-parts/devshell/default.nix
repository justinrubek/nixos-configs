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
    ...
  }: let
    pre-commit-check = import ./pre_commit.nix inputs system;
  in rec {
    devShells = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [alejandra inputs.home-manager.packages.${system}.home-manager hcloud packer inputs'.deploy-rs.packages.deploy-rs];
        inherit (pre-commit-check) shellHook;
      };
    };

    checks = {
      pre-commit = pre-commit-check;
    };
  };
}
