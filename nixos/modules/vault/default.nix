{self, ...}: {
  config,
  pkgs,
  lib,
  flakeRootPath,
  ...
}: let
  cfg = config.justinrubek.vault;
in {
  options.justinrubek.vault = {
    enable = lib.mkEnableOption "configure vault";
  };

  config = lib.mkIf cfg.enable {
    services.vault = {
      enable = true;

      address = "0.0.0.0:8200";

      storageBackend = "file";
      extraConfig = ''
        ui = true
      '';

      # TODO: use regular vault package after 1.12.3 is released
      # https://github.com/hashicorp/vault/issues/17527
      package = self.packages.${pkgs.system}.vault-bin;
    };

    networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
      allowedTCPPorts = [8200];
    };
  };
}
