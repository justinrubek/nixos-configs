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
  in rec {
    packages = {
      nomad = pkgs.callPackage ./nomad {};
      vault-bin = pkgs.callPackage ./vault-bin {};
    };
  };
}
