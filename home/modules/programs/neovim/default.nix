{neovim-nightly-overlay, ...} @ inputs: {
  config,
  lib,
  pkgs,
  ...
} @ module-inputs: let
  cfg = config.programs.univim;

  nixvim = inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
    module = import ./config.nix (module-inputs // {username = cfg.user;});
  };
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
    # programs.nixvim = import ./config.nix (module-inputs // {username = cfg.user;});
    home.packages = [nixvim];
  };
}
