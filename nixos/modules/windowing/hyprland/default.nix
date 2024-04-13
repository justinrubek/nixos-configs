inputs @ {...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.windowing.hyprland;
in {
  options.justinrubek.windowing.hyprland = {
    enable = lib.mkEnableOption "enable hyprland";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    services.displayManager.sessionPackages = [inputs.hyprland.packages.${pkgs.system}.default];

    # Configure keymap in X11
    services.xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
}
