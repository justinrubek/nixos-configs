{nixpkgs, ...}: {
  config,
  pkgs,
  lib,
  ...
}: let
in {
  profiles.base.enable = true;
  fonts.fontconfig.enable = true;
}
