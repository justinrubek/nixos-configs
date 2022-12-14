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
    };
  };
}
