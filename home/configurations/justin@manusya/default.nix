{pkgs, ...}: {
  config = {
    activeProfiles = ["development" "browsing" "gaming" "graphical" "design" "work" "media"];

    home = {
      packages = with pkgs; [
        rofi
        (dwarf-fortress-packages.dwarf-fortress-full.override {
          enableIntro = false;
        })
      ];
      stateVersion = "22.05";
    };

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    services.syncthing = {
      enable = true;
      tray.enable = true;
    };

    programs = {
      nushell.enable = true;
      pandoc.enable = true;
      zellij = {
        enable = true;
        settings = {
          default-shell = "zsh";
        };
      };
    };
  };
}
