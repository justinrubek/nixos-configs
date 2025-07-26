{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    system,
    inputs',
    self',
    ...
  }: {
    devShells = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra
          inputs.home-manager.packages.${system}.home-manager
          pkgs.nh

          pkgs.age
          pkgs.ssh-to-age
          pkgs.sops

          inputs'.nix-postgres.packages."psql_15/bin"

          pkgs.calibre
        ];

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
  };
}
