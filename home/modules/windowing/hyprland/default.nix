_: {
  config,
  lib,
  pkgs,
  ...
} @ inputs: let
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
    terminal = "alacritty";
    launcher = "wofi --show drun";
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
      pkgs.alacritty
      pkgs.playerctl
      pkgs.wireplumber
    ];

    wayland.windowManager.hyprland.enable = true;

    xdg.configFile."wlogout/layout".source = ./wlogout.conf;

    wayland.windowManager.hyprland.extraConfig = ''
      $mod = SUPER
      $modalt = SUPER_ALT

      # TODO: monitor configuration

      # bar launch
      exec-once = eww open bar

      misc {
        # enable variable frame rate
        no_vfr = 0

        # no need for auto-reload on nix
        disable_autoreload = 1

        # focus_on_activate = 1
      }

      input {
        kb_layout = us

        # focus windows on mouse hover
        follow_mouse = 1

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
        gaps_in = 5
        gaps_out = 5
        border_size = 2

        col.active_border = rgb(${colors.blue}) rgb(${colors.mauve}) 270deg
        col.inactive_border = rgb(${colors.crust}) rgb(${colors.lavender}) 270deg
      }

      decoration {
        rounding = 16
        blur = 1
        blur_size = 3
        blur_passes = 3
        blur_new_optimizations = 1

        drop_shadow = 1
        shadow_ignore_window = 1
        shadow_offset = 2 2
        shadow_range = 4
        shadow_render_power = 1
        col.shadow = 0x55000000
      }

      animations {
        enabled = 1
        animation = border, 1, 2, default
        animation = fade, 1, 4, default
        animation = windows, 1, 3, default, popin 80%
        animation = workspaces, 1, 2, default, slide
      }

      dwindle {
        pseudotile = 1
        preserve_split = 1

        col.group_border_active = rgb(${colors.pink})
        col.group_border = rgb(${colors.surface0})
      }

      # disable idle when watching video
      windowrulev2 = idleinhibit fullscreen, class:^(firefox)$

      # launch terminal
      bind = $mod, Return, exec, ${apps.terminal}
      bind = $mod, Space, exec, ${apps.launcher}

      # mouse manipulation
      # https://wiki.hyprland.org/Configuring/Binds/#mouse-binds
      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow

      # windowing commands
      ## compositor
      bind = $modalt, M, exit,
      bind = $mod, Q, killactive,
      bind = $mod, F, fullscreen,
      bind = $mod, R, togglesplit,
      bind = $mod, T, togglefloating,
      bind = $mod, P, pseudo
      ## focus navigation
      bind = $mod, h, movefocus, l
      bind = $mod, l, movefocus, r
      bind = $mod, k, movefocus, u
      bind = $mod, j, movefocus, d
      ## grouped windows
      bind = $mod, G, togglegroup,
      bind = $mod SHIFT, N, changegroupactive, f
      bind = $mod SHIFT, P, changegroupactive, b
      ## logout
      bind = $mod, Escape, exec, wlogout -p layer-shell
      ## emoji picker
      bind = $mod, E, exec, ${apps.emoji}

      # media
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioStop, exec, playerctl stop
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPrev, exec, playerctl previous
      bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindle = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

      # workspaces
      # binds mod + [shift] {1..10} to [move to] workspace {1..10}
      ${
        builtins.concatStringsSep "\n" (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));

            wsStr = toString (x + 1);
          in ''
            bind = $mod, ${ws}, workspace, ${wsStr}
            bind = $mod SHIFT, ${ws}, movetoworkspace, ${wsStr}
          ''
        )
        10)
      }

      # special workspace
      bind = $mod SHIFT, grave, movetoworkspace, special
      bind = $mod, grave, togglespecialworkspace

      # cycle through workspaces
      bind = $mod, bracketleft, workspace, m-1
      bind = $mod, bracketright, workspace, m+1

      # cycle through monitors
      bind = $mod SHIFT, bracketleft, focusmonitor, l
      bind = $mod SHIFT, bracketright, focusmonitor, r

      # global keybinds
      # teamspeak push to talk
      bind = ,mouse:276, pass, ^(TeamSpeak 3)$
    '';
  };
}
