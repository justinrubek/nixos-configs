inputs: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.justinrubek.programs.pijul;
in {
  options.justinrubek.programs.pijul = {
    enable = lib.mkEnableOption "Enable pijul";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.pijul;
      description = "The pijul package to use";
    };

    config = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "The username for pijul";
      };

      full_name = lib.mkOption {
        type = lib.types.str;
        description = "The human readable name for pijul";
      };

      email = lib.mkOption {
        type = lib.types.str;
        description = "The email for pijul";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    xdg.configFile."pijul/config.toml".source = pkgs.writeText "pijul-config" ''
      [author]
      name = "${cfg.config.name}"
      full_name = "${cfg.config.full_name}"
      email = "${cfg.config.email}"
    '';
  };
}
