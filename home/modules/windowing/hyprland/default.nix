inputs: {
  config,
  flakeRootPath,
  lib,
  pkgs,
  ...
}: let
  cfg = config.justinrubek.windowing.hyprland;

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
  options.justinrubek.windowing.hyprland = {
    enable = lib.mkEnableOption "Enable hyprland configuration";

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
    programs = {
      alacritty = {
        enable = true;
        settings.keyboard.bindings = [
          {
            key = "Enter";
            mods = "Control";
            action = "CreateNewWindow";
          }
        ];
      };
      hyprlock = {
        enable = true;
        settings = {
          general = {
            grace = 300;
            no_fade_in = false;
          };
          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
            }
          ];
          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              outline_thickness = 5;
              shadow_passes = 2;
            }
          ];
        };
      };
      waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 32;
            output = lib.attrsets.mapAttrsToList (name: monitor: monitor.name) availableMonitors;
            modules-left = ["hyprland/workspaces" "tray"];
            modules-center = ["hyprland/window"];
            modules-right = ["temperature" "memory" "pulseaudio" "clock#date" "clock#time"];

            "clock#date" = {
              format = "    {:%Y-%m-%d}";
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
              # persistent-workspaces = {
              #   "DP-1" = [1 2 3 4 5];
              #   "HDMI-A-1" = [6 7 8 9 10];
              # };
              window-rewrite = {
                "class<alacritty>" = icons.terminal;
                "class<discord>" = icons.discord;
                "class<element>" = icons.matrix;
                "class<firefox>" = icons.firefox;
                "class<com.github.flxzt.rnote>" = icons.rnote;
                "class<steam>" = icons.steam;
                "class<vesktop>" = icons.discord;
                "class<org.wezfurlong.wezterm>" = icons.terminal;
              };
              window-rewrite-default = icons.unknown;
            };

            "memory" = {
              format = "   {percentage}%";
            };

            "temperature" = {
              critical-threshold = 80;
              format = " {temperatureC}°C";
            };

            "pulseaudio" = {
              format = "   {volume}%";
              on-click = "pavucontrol";
            };
          };
        };
        style = ''
          @define-color date-background @black;
          @define-color date-color @white;
          @define-color time-background @white;
          @define-color time-color @black;

          window {
            background: rgba(0, 0, 0, 0.5);
            color: @text;
            font-size: 12px;
            font-family: "JetBrains Mono";
          }

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

          #temperature {
            padding: 0 8px;
            color: rgb(180, 84, 4);
          }

          #memory {
            padding: 0 8px;
            color: rgb(0, 64, 8);
          }

          #pulseaudio {
            padding: 0 8px;
            color: rgb(0, 255, 255);
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
      wezterm = {
        enable = true;
        enableZshIntegration = true;
        extraConfig = builtins.readFile ./wezterm.lua;
        package = inputs.wezterm.packages.${pkgs.system}.default;
      };
      wlogout = {
        enable = true;
        layout = [
          {
            label = "lock";
            action = apps.hyprlock;
            text = "Lock";
            keybind = "l";
          }
          {
            label = "logout";
            action = apps.logout;
            text = "Logout";
            keybind = "e";
          }
          {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
          }
          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
          }
        ];
      };
    };

    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 900;
              on-timeout = apps.hyprlock;
            }
            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
      hyprpaper = let
        wallpaperMonitors = lib.attrsets.filterAttrs (name: monitor: monitorExists monitor && monitorHasWallpaper monitor) cfg.monitors;

        preloads = lib.attrsets.mapAttrsToList (name: monitor: monitor.wallpaper) wallpaperMonitors;
        wallpapers = lib.attrsets.mapAttrsToList (name: monitor: "${monitor.name},${monitor.wallpaper}") wallpaperMonitors;
      in {
        enable = true;
        inherit preloads wallpapers;
      };

      mako = {
        enable = true;
        defaultTimeout = 7;
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      settings = {
        "$mod" = "SUPER";
        "$modalt" = "SUPER_ALT";

        animations = {
          enabled = true;
          animation = [
            "border, 1, 2, default"
            "fade, 1, 4, default"
            "windows, 1, 3, default, popin 80%"
            "workspaces, 1, 2, default, slide"
          ];
        };
        bind =
          [
            "$mod, Return, exec, ${apps.terminal}"
            "$mod, Space, exec, ${apps.launcher}"
            "$mod, Escape, exec, wlogout -p layer-shell" # logout
            "$mod, E, exec, ${apps.emoji}" # emoji picker
            # compositor
            "$modalt, M, exit,"
            "$mod, Q, killactive,"
            "$mod, F, fullscreen,"
            "$mod, R, togglesplit,"
            "$mod, T, togglefloating,"
            "$mod, P, pseudo"
            # focus navigation
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"
            # grouped windows
            "$mod, G, togglegroup,"
            "$mod SHIFT, L, changegroupactive, f"
            "$mod SHIFT, H, changegroupactive, b"
            # special workspace
            "$mod SHIFT, grave, movetoworkspace, special"
            "$mod, grave, togglespecialworkspace"
            # cycle through workspaces
            "$mod, bracketleft, workspace, m-1"
            "$mod, bracketright, workspace, m+1"
            # cycle through monitors
            "$mod SHIFT, bracketleft, focusmonitor, l"
            "$mod SHIFT, bracketright, focusmonitor, r"
          ]
          ++ (builtins.genList (
              x: let
                s = toString x;
              in ''
                bind = $mod, ${s}, workspace, ${s}
              ''
            )
            10)
          ++ (builtins.genList (
              x: let
                s = toString x;
              in ''
                bind = $mod SHIFT, ${s}, movetoworkspace, ${s}
              ''
            )
            10);
        bindl = [
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioStop, exec, playerctl stop"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];
        bindle = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        decoration = {
          rounding = 16;
          blur = {
            enabled = true;
            size = 3;
            passes = 3;
            new_optimizations = true;
          };
          drop_shadow = true;
          shadow_ignore_window = true;
          shadow_offset = "2 2";
          shadow_range = 4;
          shadow_render_power = 1;
          "col.shadow" = "0x55000000";
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        exec-once = [
          "waybar"
        ];
        general = {
          border_size = 2;
          gaps_in = 5;
          gaps_out = 5;
          layout = "dwindle";

          "col.active_border" = "rgb(${colors.blue}) rgb(${colors.mauve}) 270deg";
          "col.inactive_border" = "rgb(${colors.crust}) rgb(${colors.lavender}) 270deg";
        };
        group = {
          groupbar = {
            font_size = 12;
            gradients = false;
          };

          "col.border_active" = "${colors.pink}";
          "col.border_inactive" = "${colors.surface0}";
        };
        input = {
          kb_layout = "us";
          follow_mouse = true;
          mouse_refocus = false;
          sensitivity = 0;
        };
        misc = {
          vfr = true;
          disable_autoreload = true; # no need for auto-reload on nix
        };
        monitor = let
          getMonitor = {
            name,
            resolution,
            refreshRate,
            position,
            scale,
            ...
          }: "${name}, ${resolution}@${builtins.toString refreshRate}, ${position}, ${scale}";
          monitors = lib.attrsets.mapAttrsToList (name: getMonitor) availableMonitors;
        in
          monitors;
        windowrulev2 = [
          # disable idle when watching video
          "idleinhibit fullscreen, class:^(firefox)$"
          # floating windows
          "float,title:(SpeedCrunch)"
          "size 50% 50%,title:(SpeedCrunch)"
          # workspaced windows
          "workspace 9, class:(.*iscord.*)"
          "workspace 9, title:(Teamspeak 3)"
          # steam
          "workspace 5 silent, class:(steam)"
          "workspace special silent, class:(steam), title:(Sign in to Steam)"
          "float, class:(steam), title:(Friends List)"
          "size 400 600, class:(steam), title:(Friends List)"
        ];
      };
    };
  };
  _file = ./default.nix;
}
