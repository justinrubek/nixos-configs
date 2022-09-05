{self, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.browsing;

  inherit (config.home) username;
in {
  options.profiles.browsing = {
    enable = lib.mkEnableOption "browsing profile";
  };

  config = lib.mkIf cfg.enable {
    programs.ufirefox = {
      enable = true;
      inherit username;
    };

    home.packages = with pkgs; [
      brave
    ];
  };
}
