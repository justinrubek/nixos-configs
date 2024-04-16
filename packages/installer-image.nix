{ inputs, ... }:
{
  perSystem =
    {
      config,
      pkgs,
      system,
      ...
    }:
    let
      graphical = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma5.nix"
        ];
      };
      minimal = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix" ];
      };
    in
    rec {
      packages = {
        "installer/graphical" = graphical.config.system.build.isoImage;
        "installer/minimal" = minimal.config.system.build.isoImage;
      };
    };
}
