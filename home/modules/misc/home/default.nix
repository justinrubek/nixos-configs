{nixpkgs, ...}: {
  config,
  pkgs,
  lib,
  ...
}: {
  profiles.base.enable = true;
  fonts.fontconfig.enable = true;
}
