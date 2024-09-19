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
          inputs.home-manager.packages.${system}.home-manager
          pkgs.nh
        ];

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
  };
}
