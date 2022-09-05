_: {
  config,
  lib,
  pkgs,
  ...
} @ inputs: let
  univimEnabled = config.programs.univim.enable;
in {
  options.programs.univim = {
    enable = lib.mkEnableOption "Enable neovim";
  };

  config = lib.mkIf univimEnabled {
    programs.nixvim = import ./config.nix inputs;
  };
}
