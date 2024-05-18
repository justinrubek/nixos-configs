_: {
  config,
  lib,
  pkgs,
  ...
} @ inputs: let
  cfg = config.justinrubek.windowing.waybar;
  icons = {
    discord = "󰙯";
    firefox = "";
    matrix = "󰘨";
    steam = "";
    terminal = "";
    unknown = "";
  };
in {
  options.justinrubek.windowing.waybar = {
    enable = lib.mkEnableOption "Enable waybar configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 32;
          output = [
            "HDMI-A-1"
            "DP-1"
          ];
          modules-left = ["hyprland/workspaces" "tray"];
          modules-center = ["hyprland/window"];
          modules-right = ["temperature" "memory" "pulseaudio" "clock#date" "clock#time"];

          "clock#date" = {
            format = "{:%Y-%m-%d}";
            interval = 20;
          };

          "clock#time" = {
            format = "{:%H:%M:%S}";
            interval = 1;
          };

          "custom/powermenu" = {
            "format" = "";
            "on-click" = "sleep 0.1 && wlogout -p layer-shell";
            "tooltip" = false;
          };

          "hyprland/window" = {
            separate-outputs = true;
          };

          "hyprland/workspaces" = {
            format = "{icon} {windows}";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            all-outputs = true;
            on-click = "activate";
            persistent-workspaces = {
              "DP-1" = [1 2 3 4 5];
              "HDMI-A-1" = [6 7 8 9 10];
            };
            window-rewrite = {
              "class<alacritty>" = icons.terminal;
              "class<discord>" = icons.discord;
              "class<element>" = icons.matrix;
              "class<firefox>" = icons.firefox;
              "class<steam>" = icons.steam;
              "class<vesktop>" = icons.discord;
              "class<org.wezfurlong.wezterm>" = icons.terminal;
            };
            window-rewrite-default = icons.unknown;
          };

          "temperature" = {
            critical-threshold = 80;
            format = " {temperatureC}°C";
          };
        };
      };
      style = ''
        @define-color date-background @black;
        @define-color date-color @white;
        @define-color time-background @white;
        @define-color time-color @black;

        #clock,
        #workspaces,
        #memory,
        #temperature {
          padding: 0 8px;
        }

        #clock.date {
          background-color: @date-background;
          color: @date-color;
        }

        #clock.time {
          background-color: @time-background;
          color: @time-color;
        }

        #workspaces button {
          padding: 0 0.5em;
          background-color: @surface0;
          color: @text;
          margin: 0.25em;
        }

        #workspaces button:hover {
          box-shadow: inset 0 0 0 1px @blue;
        }

        #workspaces button.empty {
          color: @overlay0;
        }

        #workspaces button.visible {
          color: @blue;
        }

        #workspaces button.active {
          color: @green;
        }

        #workspaces button.urgent {
          background-color: @red;
          border-radius: 1em;
          color: @text;
        }
      '';
    };
  };
}
