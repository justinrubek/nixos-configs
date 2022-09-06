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
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
      };
    };
  };
}
