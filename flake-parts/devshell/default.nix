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
    ...
  }: let
    pre-commit-check = import ./pre_commit.nix inputs system;
  in rec {
    devShells = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [alejandra inputs.home-manager.packages.${system}.home-manager];
        inherit (pre-commit-check) shellHook;
      };
    };

    checks = {
      pre-commit = pre-commit-check;
    };
  };
}
