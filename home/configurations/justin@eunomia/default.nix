{comma, ...} @ inputs: {pkgs, ...}: let
in {
  config = {
    activeProfiles = ["development" "browsing" "gaming" "graphical" "design" "work" "media"];

    programs.thunderbird = {
      enable = true;

      profiles = {
        "justin" = {
          isDefault = true;
        };
      };
    };

    justinrubek = {
      windowing.hyprland.enable = true;
      wayland = {
        common.enable = true;

        swaylock.enable = true;
      };
    };

    home.packages = with pkgs; [
      rofi
      (dwarf-fortress-packages.dwarf-fortress-full.override {
        enableIntro = false;
      })
      comma.packages.x86_64-linux.default
      alejandra
      prismlauncher

      pkgs.microsoft-edge
      pkgs.libreoffice

      inputs.generation-toolkit.packages.${pkgs.system}.generation-toolkit

      pkgs.wezterm

      pkgs.fluffychat

      inputs.project-runner.packages.${pkgs.system}.project-runner

      pkgs.tiled
      pkgs.pavucontrol
      pkgs.tokei

      (pkgs.lutris.override {
        extraLibraries = pkgs: [];
      })
    ];

    programs.zellij = {
      enable = true;
      settings = {
        default-shell = "zsh";
      };
    };

    xdg.configFile."pgcli/config".source = ./pgcli.config;

    programs.obs-studio.enable = true;
  };
}
