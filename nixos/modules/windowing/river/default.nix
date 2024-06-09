inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.windowing.river;
in {
  options.justinrubek.windowing.river = {
    enable = lib.mkEnableOption "enable river";
  };

  config = lib.mkIf cfg.enable {
    programs.river.enable = true;
    services.displayManager.sessionPackages = [pkgs.river];
  };
}
