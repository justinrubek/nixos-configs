_: {
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
    users.users.admin = {
      name = "admin";
      isNormalUser = true;
      extraGroups = ["wheel"];

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1Uj62/yt8juK3rSfrVuX/Ut+xzw1Z75KZS/7fOLm6l"
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
