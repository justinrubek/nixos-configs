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
      # see https://github.com/NixOS/nixpkgs/issues/78961
      (discord.override {nss = pkgs.nss_latest;})
    ];
  };
}
