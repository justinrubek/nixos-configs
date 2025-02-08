{
  config,
  inputs',
  lib,
  pkgs,
  self',
  ...
}: let
  cfg = config.justinrubek.mediahost;
in {
  imports = [./suwayomi.nix];

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
        packages = [
          inputs'.epify.packages.epify
          (pkgs.beets.override {
            pluginOverrides = {
              lyrics.enable = true;
            };
          })
          self'.packages.neovim
        ];
        shell = pkgs.bashInteractive;
      };

      services = {
        deluge = {
          inherit user;
          enable = false;
          dataDir = "/home/${user}/deluge";
          web = {
            enable = true;
            port = 8112;
          };
        };
        jellyfin = {
          inherit user;
          enable = true;
        };
        navidrome = {
          inherit user;
          enable = true;
          settings = {
            Address = "0.0.0.0";
            MusicFolder = "/home/${user}/music";
            Port = 8114;
          };
        };
        suwayomi = {
          inherit user;
          enable = true;
          dataDir = "/home/${user}/.local/share/Tachidesk";
          settings.server = {
            localSourcePath = "/home/${user}/.local/share/Tachidesk/local";
            port = 8113;
          };
        };
      };

      networking.firewall.interfaces.${config.services.tailscale.interfaceName} = let
        ports = {
          jellyfin = [8096];
          suwayomi = [config.services.suwayomi.settings.server.port];
          navidrome = [config.services.navidrome.settings.Port];
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

      systemd.services.navidrome.serviceConfig.ProtectHome = lib.mkForce false;
    };
}
