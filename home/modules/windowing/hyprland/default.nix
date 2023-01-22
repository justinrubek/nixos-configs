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
    terminal = "kitty";
    launcher = "wofi --show drun";
  };
in {
  options.justinrubek.windowing.hyprland = {
    enable = lib.mkEnableOption "Enable hyprland configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.xorg.xprop
      pkgs.kitty
      pkgs.wofi
      pkgs.alacritty
    ];

    wayland.windowManager.hyprland.enable = true;

    wayland.windowManager.hyprland.extraConfig = ''
      $mod = SUPER

      # TODO: monitor configuration

      # TODO: bar launch

      misc {
        # enable variable frame rate
        no_vfr = 0

        # no need for auto-reload on nix
        disable_autoreload = 1

        focus_on_activate = 1
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

      # TODO: disable idle when watching video

      # launch terminal
      bind = $mod, Return, exec, ${apps.terminal}
      bind = $mod, Q, exec, alacritty
      bind = $mod, M, exit,
      bind = $mod, R, exec, ${apps.launcher}

      # workspace navigation
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9
      bind = $mod, 0, workspace, 10
    '';
  };
}
