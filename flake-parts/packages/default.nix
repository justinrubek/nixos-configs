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
    iso = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        "${inputs.unixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma5.nix"
      ];
    };
  in rec {
    packages = {
      iso = iso.config.system.build.isoImage;
    };
  };
}
