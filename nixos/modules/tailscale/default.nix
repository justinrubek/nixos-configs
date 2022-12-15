{self, ...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.nomad;
in {
  options.justinrubek.tailscale = {
    enable = lib.mkEnableOption "configure tailscale";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
    networking.firewall.checkReversePath = "loose";
    networking.nameservers = ["100.100.100.100" "1.1.1.1" "8.8.8.8"];
    networking.search = ["tailfef00.ts.net"];
  };
}
