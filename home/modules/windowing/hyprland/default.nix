inputs: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.justinrubek.windowing.hyprland;

  colors = {
    mauve = "c0a2c7";
    blue = "7aa2f7";
    crust = "f7c07a";
    lavender = "e0b0ff";
    surface0 = "f7f7f7";
    pink = "f7a2a2";
  };

  apps = {
    terminal = "wezterm";
    launcher = "wofi --show drun --style ${./wofi-style.css}";
    emoji = "${pkgs.wofi-emoji}/bin/wofi-emoji";
  };
in {
  options.justinrubek.windowing.hyprland = {
    enable = lib.mkEnableOption "Enable hyprland configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.wf-recorder
      pkgs.xorg.xprop
      pkgs.wofi
      pkgs.playerctl
      pkgs.wireplumber
      pkgs.wl-clipboard
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
            action = "swaylock";
            text = "Lock";
            keybind = "l";
          }
          {
            label = "logout";
            action = "${pkgs.wayland-logout}/bin/wayland-logout";
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
              timeout = 1500;
              on-timeout = "hyprlock";
            }
            {
              timeout = 1600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
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
        monitor = [
          "HDMI-A-1, 2560x1440@100, 1920x0, auto"
          "DP-1, 1920x1080@144, 0x0, auto"
        ];
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
        workspace = [
          "HDMI-A-1, 1"
          "DP-1, 10"
        ];
      };
    };
  };
}
