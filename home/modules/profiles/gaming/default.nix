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
    home.packages = [
      pkgs.protontricks
      pkgs.mangohud
      pkgs.teamspeak_client
      # see https://github.com/NixOS/nixpkgs/issues/78961
      (pkgs.discord.override {
        nss = pkgs.nss_latest;
        # withOpenASAR = true;
      })
      pkgs.airshipper
      pkgs.runelite
      pkgs.teamspeak5_client
    ];
  };
}
