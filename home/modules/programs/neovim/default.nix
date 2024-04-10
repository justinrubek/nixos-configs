{neovim-nightly-overlay, ...} @ inputs: {
  config,
  lib,
  pkgs,
  ...
} @ module-inputs: let
  cfg = config.programs.univim;

  nixvim = inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
    module = import ./config.nix module-inputs;
  };
in {
  options.programs.univim = {
    enable = lib.mkEnableOption "Enable neovim";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [nixvim];
  };
}
