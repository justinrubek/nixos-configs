_: {
  config,
  lib,
  pkgs,
  ...
} @ inputs: let
  cfg = config.justinrubek.wayland.swaylock;
in {
  options.justinrubek.wayland.swaylock = {
    enable = lib.mkEnableOption "Enable swaylock";

    swayidle.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable swayidle";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.swaylock-effects
    ];

    programs.swaylock = {
      settings = {
        clock = true;
        effect-blur = "30x3";
        font = "Roboto";
        ignore-empty-password = true;
        indicator = true;
      };
    };

    services.swayidle = lib.mkIf cfg.swayidle.enable {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
        }
        {
          event = "lock";
          command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
        }
      ];

      timeouts = [
        {
          timeout = 900;
          command = "${pkgs.systemd}/bin/loginctl lock-session";
        }
      ];
    };
  };
}
