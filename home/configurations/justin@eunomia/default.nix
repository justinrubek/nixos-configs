{comma, ...} @ inputs: {
  pkgs,
  flakeRootPath,
  ...
}: {
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
        hyprland = {
          enable = true;
          monitors = {
            primary = {
              name = "HDMI-A-1";
              position = "1920x0";
              refreshRate = 100;
              resolution = "2560x1440";
              scale = "auto";
              wallpaper = "${flakeRootPath}/wallpapers/mountain-stream.png";
            };
            secondary = {
              name = "DP-1";
              position = "0x0";
              refreshRate = 144;
              resolution = "1920x1080";
              scale = "auto";
              wallpaper = "${flakeRootPath}/wallpapers/shiny_purple.png";
            };
          };
        };
        river.enable = true;
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
        pkgs.element-desktop

        inputs.project-runner.packages.${pkgs.system}.project-runner

        pkgs.tiled
        pkgs.pavucontrol
        pkgs.tokei

        (pkgs.lutris.override {
          extraLibraries = pkgs: [];
        })
        inputs.nix-gaming.packages.${pkgs.system}.star-citizen
      ];

      stateVersion = "22.11";
    };

    xdg.configFile."pgcli/config".source = ./pgcli.config;

    global-keybind = {
      enable = true;
      device = "/dev/input/event5";
      display = ":1";
      key_to_press = 276;
      key_to_send = "F10";
    };
  };
}
