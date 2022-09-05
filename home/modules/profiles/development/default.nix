{self, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.development;
in {
  options.profiles.development = {
    enable = lib.mkEnableOption "development profile";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        package = pkgs.gitFull;
        userName = "Justin Rubek";
        userEmail = "25621857+justinrubek@users.noreply.github.com";
        delta.enable = true;
      };

      broot = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
