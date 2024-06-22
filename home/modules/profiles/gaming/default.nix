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
      pkgs.winetricks
      pkgs.teamspeak_client
      # see https://github.com/NixOS/nixpkgs/issues/78961
      (pkgs.vesktop.override {
        withSystemVencord = false;
      })
      pkgs.airshipper
      pkgs.runelite
      pkgs.teamspeak5_client
    ];

    # add a .Desktop entry for Vesktop called "Discord"
    xdg.desktopEntries = {
      discord = {
        name = "Discord";
        exec = "vesktop";
        genericName = "Discord";
        terminal = false;
      };
    };
  };
}
