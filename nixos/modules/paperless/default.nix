{
  config,
  lib,
  inputs',
  pkgs,
  ...
}:
with lib; let
  cfg = config.justinrubek.services.paperless;
in {
  options = {
    justinrubek.services.paperless = {
      enable = mkEnableOption (lib.mdDoc "PostgreSQL Server");
    };
  };

  config = mkIf cfg.enable {
    services.paperless = {
      enable = true;
      address = "0.0.0.0";
    };
    systemd.services = {
      sftpgo = let
        dataDir = "/var/lib/paperless";

        configFile = pkgs.writeText "sftpgo.json" (lib.strings.toJSON sftpgoConfig);
        sftpgoConfig = {
          ftpd = {
            bindings = [
              {
                port = 21040;
                address = "0.0.0.0";
              }
            ];
          };
          httpd = {
            bindings = [
              {
                port = 21041;
                address = "0.0.0.0";
              }
            ];
            templates_path = "${inputs'.sftpgo.packages.template-files}";
            static_files_path = "${inputs'.sftpgo.packages.static-files}";
          };
          smtp = {
            templates_path = "${inputs'.sftpgo.packages.template-files}";
          };
        };
      in {
        description = "file server";
        requires = ["network.target"];
        serviceConfig = {
          ExecStart = "${inputs'.sftpgo.packages.default}/bin/sftpgo serve --config-file ${configFile}";
          ReadWritePaths = [dataDir];
          User = "paperless";
          WorkingDirectory = dataDir;
        };
      };
    };
  };
}
