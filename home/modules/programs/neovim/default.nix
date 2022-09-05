_: {
  config,
  lib,
  pkgs,
  ...
}: let
in {
  options.programs.univim = {
    enable = lib.mkEnableOption "Enable neovim";
  };
}
