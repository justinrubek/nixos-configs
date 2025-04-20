{
  inputs,
  pkgs,
  self,
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
        enable = false;
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
              name = "DP-1";
              position = "0x0";
              refreshRate = 144;
              resolution = "2560x1440";
              scale = "auto";
              wallpaper = "${self}/wallpapers/mountain-stream.png";
            };
            secondary = {
              name = "DP-2";
              position = "2560x0";
              refreshRate = 60;
              resolution = "2560x1440";
              scale = "auto";
              wallpaper = "${self}/wallpapers/shiny_purple.png";
            };
          };
          screen-lock.enable = true;
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
        # (dwarf-fortress-packages.dwarf-fortress-full.override {
        #   enableIntro = false;
        # })
        alejandra
        prismlauncher

        pkgs.libreoffice

        inputs.generation-toolkit.packages.${pkgs.system}.generation-toolkit

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
