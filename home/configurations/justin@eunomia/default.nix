{comma, ...}: {pkgs, ...}: let
in {
  config = {
    activeProfiles = ["development" "browsing" "gaming" "graphical" "design" "work" "media"];

    home.packages = with pkgs; [
      rofi
      (dwarf-fortress-packages.dwarf-fortress-full.override {
        enableIntro = false;
      })
      comma.packages.x86_64-linux.default
      alejandra
      prismlauncher
    ];

    programs.zellij = {
      enable = true;
      settings = {
        default-shell = "zsh";
      };
    };
  };
}
