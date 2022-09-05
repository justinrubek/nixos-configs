{
  unixpkgs,
  nurpkgs,
  self,
  ...
} @ inputs: {
  pkgs,
  username,
  ...
}: let
in {
  config = {
    activeProfiles = ["development" "browsing" "gaming" "graphical" "design" "work" "media"];

    home.packages = with pkgs; [
      rofi
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
  };
}
