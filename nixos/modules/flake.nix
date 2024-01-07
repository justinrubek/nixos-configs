{nixpkgs, ...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nix.flakes;

  channelBase = "/etc/nixpkgs/channels";
  nixpkgsChannel = "${channelBase}/nixpkgs";
in {
  options.nix.flakes.enable = lib.mkEnableOption "nix flakes";

  config = lib.mkIf cfg.enable {
    nix = {
      settings.experimental-features = "nix-command flakes";

      registry.nixpkgs.flake = nixpkgs;

      nixPath = [
        "nixpkgs=${nixpkgs}"
      ];
    };

    /*
    systemd.tmpfiles.rules = [
      "L+ ${nixpkgsChannel} - - - - ${nixpkgs}"
    ];
    */
  };
}
