{self, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.work;
in {
  options.profiles.work = {
    enable = lib.mkEnableOption "work profile";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
      zoom-us
    ];
  };
}
