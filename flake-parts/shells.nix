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
        buildInputs =
          [
            inputs.home-manager.packages.${system}.home-manager
            pkgs.nh
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            inputs'.nix-darwin.packages.darwin-rebuild
          ];

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
  };
}
