{self, ...}: {
  config,
  pkgs,
  lib,
  flakeRootPath,
  ...
}: let
  cfg = config.justinrubek.tailscale;
in {
  options.justinrubek.tailscale = {
    enable = lib.mkEnableOption "configure tailscale";

    autoconnect.enable = lib.mkEnableOption "autoconnect to tailscale";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
    networking.firewall.checkReversePath = "loose";
    networking.nameservers = ["100.100.100.100" "1.1.1.1" "8.8.8.8"];
    networking.search = ["tailfef00.ts.net"];

    sops.secrets."tailscale_key" = {
      sopsFile = "${flakeRootPath}/secrets/tailscale/server.yaml";
    };

    systemd.services.tailscale-autoconnect = let
      tailscale = pkgs.lib.getExe pkgs.tailscale;
      jq = pkgs.lib.getExe pkgs.jq;
    in
      lib.mkIf cfg.autoconnect.enable {
        description = "Automatically connect to tailscale";
        after = ["network-pre.target" "tailscale.service"];
        wants = ["network-pre.target" "tailscale.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig.Type = "oneshot";
        script = ''
          # wait for tailscale to be ready
          sleep 3

          # check if tailscale is already connected
          status="$(${tailscale} status -json | ${jq} -r .BackendState)"
          if [ $status = "Running" ]; then
            echo "Tailscale is already connected"
            exit 0
          fi

          # connect to tailscale
          ${tailscale} up -authkey file:${config.sops.secrets."tailscale_key".path}
        '';
      };
  };
}
