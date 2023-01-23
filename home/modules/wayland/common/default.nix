_: {
  config,
  lib,
  pkgs,
  ...
} @ inputs: let
  cfg = config.justinrubek.wayland.common;
in {
  options.justinrubek.wayland.common = {
    enable = lib.mkEnableOption "Enable common wayland configuration";

    faketray.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable faketray";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.wlogout
      pkgs.wl-clipboard
      pkgs.wlr-randr
    ];

    # https://github.com/nix-community/home-manager/issues/2064
    systemd.user.targets.tray = lib.mkIf cfg.faketray.enable {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
  };
}
