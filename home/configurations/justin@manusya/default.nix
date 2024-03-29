_: {pkgs, ...}: {
  config = {
    activeProfiles = ["development" "browsing" "gaming" "graphical" "design" "work" "media"];

    home.packages = with pkgs; [
      rofi
      (dwarf-fortress-packages.dwarf-fortress-full.override {
        enableIntro = false;
      })
    ];

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    services.syncthing = {
      enable = true;
      tray.enable = true;
    };

    programs.pandoc.enable = true;

    programs.zellij = {
      enable = true;
      settings = {
        default-shell = "zsh";
      };
    };

    programs.nushell.enable = true;
  };
}
