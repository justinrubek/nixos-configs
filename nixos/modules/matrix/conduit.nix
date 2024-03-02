{...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.matrix.conduit;
in {
  options.justinrubek.matrix.conduit = {
    enable = lib.mkEnableOption "enable conduit matrix homeserver";

    server_name = lib.mkOption {
      type = lib.types.str;
      description = "The hostname that will appear in user and room IDs";
    };

    matrix_hostname = lib.mkOption {
      type = lib.types.str;
      description = "The hostname that conduit actually runs on";
      default = cfg.server_name;
    };

    admin_email = lib.mkOption {
      type = lib.types.str;
      description = "The email address of the server administrator";
    };
  };

  config = let
    well_known_server = pkgs.writeText "well-known-matrix-server" ''
      {
        "m.server": "${cfg.matrix_hostname}"
      }
    '';
  in
    lib.mkIf cfg.enable ({} // podmanConfig // dockerConfig);
}
