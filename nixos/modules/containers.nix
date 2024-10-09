{
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

  config = let
    podmanConfig = lib.mkIf (!cfg.useDocker) {
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
        };
      };
    };

    dockerConfig = lib.mkIf cfg.useDocker {
      virtualisation = {
        docker = lib.mkIf cfg.useDocker {
          enable = true;
          autoPrune.enable = true;
        };
      };

      # give docker access to all wheels
      users.groups.docker.members = config.users.groups.wheel.members;
    };
  in
    lib.mkIf cfg.enable ({} // podmanConfig // dockerConfig);
}
