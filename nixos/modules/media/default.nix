{
  self,
  inputs,
  ...
}: {
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
    enable = lib.mkEnableOption "run media";
  };

  config = let
    user = "mediahost";
  in
    lib.mkIf cfg.enable {
      users.users.mediahost = {
        isSystemUser = true;
        home = "/home/${user}";
        createHome = true;
        group = "${user}";
        extraGroups = ["jellyfin"];
        packages = [inputs.epify.packages.${pkgs.system}.epify];
        shell = pkgs.bashInteractive;
      };

      services = {
        deluge = {
          enable = false;
          user = "${user}";
          dataDir = "/home/${user}/deluge";
          web = {
            enable = true;
            port = 8112;
          };
        };
        jellyfin = {
          enable = true;
          user = "${user}";
        };
      };

      networking.firewall.interfaces.${config.services.tailscale.interfaceName} = let
        ports = {
          jellyfin = [8096];
        };

        allPorts = lib.flatten (lib.attrValues ports);
      in {
        allowedTCPPorts = allPorts;
        allowedUDPPorts = allPorts;
      };

      networking.firewall = {
        allowedTCPPorts = [8096];
        allowedUDPPorts = [8096];
      };
    };
}
