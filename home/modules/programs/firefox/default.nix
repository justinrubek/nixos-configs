_: {
  config,
  lib,
  pkgs,
  ...
} @ inputs: let
  firefoxEnabled = config.programs.ufirefox.enable;

  inherit (config.programs.ufirefox) username;
in {
  options.programs.ufirefox = {
    enable = lib.mkEnableOption "Enable firefox";

    username = lib.mkOption {
      type = lib.types.str;
      default = "firefox";
      description = "User to configure firefox as";
    };
  };

  config = lib.mkIf firefoxEnabled {
    programs.firefox = import ./config.nix inputs username;
  };
}
