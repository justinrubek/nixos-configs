{...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.nomad;
in {
  options.justinrubek.nomad = {
    enable = lib.mkEnableOption "run nomad";
  };

  config = lib.mkIf cfg.enable {
    services.nomad = {
      enable = true;
      enableDocker = true;
    };
  };
}
