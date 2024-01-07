{
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    formatters = [
      pkgs.alejandra
    ];

    treefmt = pkgs.writeShellApplication {
      name = "treefmt";
      runtimeInputs = [pkgs.treefmt] ++ formatters;
      text = ''
        exec treefmt "$@"
      '';
    };
  in {
    packages = {
      inherit treefmt;
    };

    legacyPackages = {
      inherit formatters;
    };
  };
}
