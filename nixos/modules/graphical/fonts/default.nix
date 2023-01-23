inputs @ {self, ...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.graphical.fonts;
in {
  options.justinrubek.graphical.fonts = {
    enable = lib.mkEnableOption "enable fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      fonts = [
        self.packages.${pkgs.system}.material-symbols

        pkgs.lexend
        pkgs.nerdfonts
        pkgs.noto-fonts
        pkgs.noto-fonts-emoji

        pkgs.roboto
      ];

      fontconfig.defaultFonts = {
        serif = ["Noto Serif" "Noto Color Emoji"];
        sansSerif = ["Noto Sans" "Noto Color Emoji"];
        monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
