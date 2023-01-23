{...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.windowing.plasma;
in {
  options.justinrubek.windowing.plasma = {
    enable = lib.mkEnableOption "enable kde plasma";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.plasma5.enable = true;

    # Configure keymap in X11
    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };
  };
}
