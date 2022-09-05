{unixpkgs, ...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nix.flakes;

  channelBase = "/etc/nixpkgs/channels";
  nixpkgsChannel = "${channelBase}/nixpkgs";
  unixpkgsChannel = "${channelBase}/unixpkgs";
in {
  options.nix.flakes.enable = lib.mkEnableOption "nix flakes";

  config = lib.mkIf cfg.enable {
    nix = {
      settings.experimental-features = "nix-command flakes";

      registry.unixpkgs.flake = unixpkgs;
      registry.nixpkgs.flake = unixpkgs;

      nixPath = [
        "nixpkgs=${unixpkgs}"
        "unixpkgs=${unixpkgs}"
      ];
    };

    /*
     systemd.tmpfiles.rules = [
       "L+ ${nixpkgsChannel} - - - - ${unixpkgs}"
       "L+ ${unixpkgsChannel} - - - - ${unixpkgs}"
     ];
     */
  };
}
