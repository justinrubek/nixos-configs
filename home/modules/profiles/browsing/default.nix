{self, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.browsing;

  username = config.home.username;
in {
  options.profiles.browsing = {
    enable = lib.mkEnableOption "browsing profile";
  };

  config = lib.mkIf cfg.enable {
    programs.ufirefox = {
      enable = true;
      username = username;
    };
  };
}
