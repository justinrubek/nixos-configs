{inputs, ...}: {
  imports = [
    inputs.pre-commit-hooks.flakeModule
    ./formatting.nix
  ];
  perSystem = {self', ...}: {
    pre-commit = {
      check.enable = true;

      settings = {
        src = ../.;
        hooks = {
          treefmt.enable = true;
          statix.enable = true;
        };

        settings.treefmt.package = self'.packages.treefmt;
      };
    };
  };
}
