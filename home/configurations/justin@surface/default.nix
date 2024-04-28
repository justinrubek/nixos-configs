inputs: {pkgs, ...}: {
  config = {
    activeProfiles = ["development" "browsing" "graphical"];

    programs = {
      thunderbird = {
        enable = true;

        profiles = {
          "justin" = {
            isDefault = true;
          };
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
        swaylock.enable = true;
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
        alejandra
        pkgs.libreoffice
        pkgs.pavucontrol
        # https://github.com/NixOS/nixpkgs/pull/274016
        (pkgs.iptsd.overrideAttrs (oldAttrs: {
          mesonFlags = [
            "-Dservice_manager=systemd"
            "-Dsample_config=false"
            "-Ddebug_tools=calibrate"
            "-Db_lto=false"
          ];
        }))
      ];

      stateVersion = "24.05";
    };
  };
}
