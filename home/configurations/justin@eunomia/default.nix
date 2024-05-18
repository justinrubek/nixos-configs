{comma, ...} @ inputs: {pkgs, ...}: {
  config = {
    activeProfiles = ["development" "browsing" "gaming" "graphical" "design" "work" "media"];

    programs = {
      obs-studio.enable = true;
      thunderbird = {
        enable = true;

        profiles = {
          "justin" = {
            isDefault = true;
          };
        };
      };
      zellij = {
        enable = true;
        settings = {
          default-shell = "zsh";
        };
      };
    };

    justinrubek = {
      windowing = {
        hyprland.enable = true;
        waybar.enable = true;
      };
      wayland = {
        common.enable = true;

        swaylock.enable = false;
      };
    };

    # TODO: restore when sourcehut is back
    manual = {
      html.enable = false;
      json.enable = false;
      manpages.enable = false;
    };

    gtk = {
      enable = true;
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 22;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-enable-animations = true;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-enable-animations = true;
      };
    };

    home = {
      pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 22;
      };

      packages = with pkgs; [
        rofi
        (dwarf-fortress-packages.dwarf-fortress-full.override {
          enableIntro = false;
        })
        comma.packages.x86_64-linux.default
        alejandra
        prismlauncher

        pkgs.libreoffice

        inputs.generation-toolkit.packages.${pkgs.system}.generation-toolkit

        pkgs.fluffychat
        (pkgs.element-desktop.override {electron = pkgs.electron_28;})

        inputs.project-runner.packages.${pkgs.system}.project-runner

        pkgs.tiled
        pkgs.pavucontrol
        pkgs.tokei

        (pkgs.lutris.override {
          extraLibraries = pkgs: [];
        })
      ];

      stateVersion = "22.11";
    };

    xdg.configFile."pgcli/config".source = ./pgcli.config;

    global-keybind = {
      enable = true;
      device = "/dev/input/event5";
      display = ":1";
      key_to_press = 276;
      key_to_send = "F11";
    };
  };
}
