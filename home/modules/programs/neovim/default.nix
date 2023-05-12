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
    user = lib.mkOption {
      type = lib.types.str;
      description = "User to install neovim for";
      default = config.home.username;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = import ./config.nix (inputs // {username = cfg.user;});
  };
}
