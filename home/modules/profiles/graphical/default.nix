{
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
    home.packages = with pkgs;
      [
        gtop
        gping
        speedcrunch
        flameshot
        bitwarden
        pkgs.rnote
      ]
      ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));
  };
}
