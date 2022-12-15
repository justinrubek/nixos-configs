{...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.administration;

  inherit (config.networking) hostName;
in {
  options.justinrubek.administration = {
    enable = lib.mkEnableOption "enable admin related services";
  };

  config = lib.mkIf cfg.enable {
    # provide the `admin` user
    users.users.admin = {
      name = "admin";
      isNormalUser = true;
      extraGroups = ["wheel"];

      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsUQZGQOH2kmQNeG/Ezmsv6A/70JUO8nLh9WaZ/o7DlmpYeEyUdloTazxpP9FjuRv7d7nzRqtQFOF74TBaDEAxR9/eHxX9zc5RfyE1RYeGWPGgnuHpxoTijh70ncTlU6sr0oqP7e24qeIy7pqWKQmV8RDOkr2etbnb5OpCHEsZJ0l0sPYQpYi0Ud8cM/HFCCVPeg21wVuxBX2rA4ze8+YgnPJZRnhtHZg7rAapvhiIfDAJ3xIweauCoz0vZdmANlUsg2AoOx9b2Ym6rGNmRrJUNZYcsNxmUHc1/oc1g9NZ7GoaMhfw0BHVJ0kyfE2glpJX9iu6WHWjbL+XM0QnCFrc3hbQc41zYQsMHcY/N/P5MW9Gj77Q9P/qRDbwlVOdoFw1bUpIoMgsJ95o5gv5mClHuBLZD3ZO5cyRfnjH4w0pt6EnWtbkORsT5A7ULOQOG8AOuBL3ok/yVTVAFV2yMbaEg1BM2By0U6hn9M6SGWuOiM1oMwvVFJWdmZsvPeTZqaU= justin"
      ];
    };

    security.sudo.wheelNeedsPassword = false;
    nix.settings.trusted-users = ["@wheel"];

    services.getty.autologinUser = "admin";

    # start an ssh server
    services.openssh = {
      enable = true;

      hostKeys = [
        {
          type = "ed25519";
          path = "/etc/ssh/ssh_host_ed25519_key";
        }
      ];
    };
  };
}
