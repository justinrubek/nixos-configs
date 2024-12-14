{
  config,
  lib,
  pkgs,
  self',
  ...
}: let
  cfg = config.justinrubek.graphical.fonts;
in {
  options.justinrubek.graphical.fonts = {
    enable = lib.mkEnableOption "enable fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      packages =
        [
          self'.packages.material-symbols

          pkgs.lexend

          pkgs.noto-fonts
          pkgs.noto-fonts-emoji

          pkgs.roboto

          pkgs.iosevka
        ]
        ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));

      fontconfig.defaultFonts = {
        serif = ["Noto Serif" "Noto Color Emoji"];
        sansSerif = ["Noto Sans" "Noto Color Emoji"];
        monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
