{self, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.graphical;
in {
  options.profiles.graphical = {
    enable = lib.mkEnableOption "graphical profile";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gtop
      gping
      speedcrunch
      flameshot
      nerdfonts
      bitwarden
      element-desktop
    ];
  };
}
