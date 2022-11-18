{neovim-nightly-overlay, ...}: {
  config,
  lib,
  pkgs,
  ...
} @ inputs: let
  cfg = config.programs.univim;
in {
  options.programs.univim = {
    enable = lib.mkEnableOption "Enable neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = import ./config.nix inputs;
    nixpkgs.overlays = [
      neovim-nightly-overlay.overlay
    ];
  };
}
