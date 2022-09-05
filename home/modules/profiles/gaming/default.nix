{self, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.gaming;
in {
  options.profiles.gaming = {
    enable = lib.mkEnableOption "gaming profile";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      protontricks
      teamspeak_client
      discord
    ];
  };
}
