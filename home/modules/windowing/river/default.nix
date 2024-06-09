inputs: {
  config,
  flakeRootPath,
  lib,
  pkgs,
  ...
}: let
  cfg = config.justinrubek.windowing.river;

  colors = {
    blue = "7aa2f7";
    crust = "f7c07a";
    lavender = "e0b0ff";
    mauve = "c0a2c7";
    pink = "f7a2a2";
    surface0 = "f7f7f7";
  };

  icons = {
    discord = "󰙯";
    firefox = "";
    matrix = "󰘨";
    rnote = "󱓧";
    steam = "";
    terminal = "";
    unknown = "";
  };

  apps = {
    emoji = "${pkgs.wofi-emoji}/bin/wofi-emoji";
    hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
    launcher = "wofi --show drun --style ${./wofi-style.css}";
    logout = "${pkgs.wayland-logout}/bin/wayland-logout";
    terminal = "wezterm";
  };

  monitorType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.string;
      };
      position = lib.mkOption {
        type = lib.types.string;
      };
      refreshRate = lib.mkOption {
        type = lib.types.int;
      };
      resolution = lib.mkOption {
        type = lib.types.string;
      };
      scale = lib.mkOption {
        type = lib.types.string;
        default = "1";
      };
      wallpaper = lib.mkOption {
        type = lib.types.nullOr lib.types.string;
        default = null;
      };
    };
  };

  monitorExists = monitor: monitor != null;
  monitorHasWallpaper = monitor: monitor.wallpaper != null;
  availableMonitors = lib.attrsets.filterAttrs (name: monitorExists) cfg.monitors;
in {
  options.justinrubek.windowing.river = {
    enable = lib.mkEnableOption "Enable river configuration";

    monitors = {
      primary = lib.mkOption {
        type = monitorType;
      };
      secondary = lib.mkOption {
        type = lib.types.nullOr monitorType;
        default = null;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.playerctl
      pkgs.wf-recorder
      pkgs.wireplumber
      pkgs.wl-clipboard
      pkgs.wofi
      pkgs.xorg.xprop
    ];

    wayland.windowManager.river = {
      enable = true;
      settings = {
      };
    };
  };
  _file = ./default.nix;
}
