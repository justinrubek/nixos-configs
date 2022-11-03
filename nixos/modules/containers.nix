{...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.development.containers;
in {
  options.justinrubek.development.containers = {
    enable = lib.mkEnableOption "enable container tools";

    useDocker = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to use docker instead of podman";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = lib.mkIf (!cfg.useDocker) {
        enable = true;
        dockerCompat = true;
      };

      docker = lib.mkIf cfg.useDocker {
        enable = true;
      };
    };
  };
}
