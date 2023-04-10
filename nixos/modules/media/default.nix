{self, ...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  # Mediahost module
  # Provides Jellyfin, Sonarr, Radarr, and Jackett
  cfg = config.justinrubek.mediahost;
in {
  options.justinrubek.mediahost = {
    enable = lib.mkEnableOption "run consul";
  };

  config = let
    user = "mediahost";
  in
    lib.mkIf cfg.enable {
      # home directory for "mediahost" user
      users.users.mediahost = {
        isSystemUser = true;
        home = "/home/${user}";
        createHome = true;
        group = "${user}";
        extraGroups = ["jellyfin"];
      };

      services.jellyfin = {
        enable = true;
        user = "${user}";
      };

      services.sonarr = {
        enable = true;
        user = "${user}";
        dataDir = "/home/${user}/sonarr";
      };

      # deluge for torrenting
      services.deluge = {
        enable = false;
        user = "${user}";
        dataDir = "/home/${user}/deluge";

        web = {
          enable = true;
          port = 8112;
        };
      };

      # open service ports to the tailnet
      networking.firewall.interfaces.${config.services.tailscale.interfaceName} = let
        ports = {
          jellyfin = [8096];
        };

        allPorts = lib.flatten (lib.attrValues ports);
      in {
        allowedTCPPorts = allPorts;
        allowedUDPPorts = allPorts;
      };
    };
}
