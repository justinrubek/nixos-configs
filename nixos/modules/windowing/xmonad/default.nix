{
  config,
  lib,
  ...
}: let
  cfg = config.justinrubek.windowing.xmonad;
in {
  options.justinrubek.windowing.xmonad = {
    enable = lib.mkEnableOption "enable xmonad";
  };

  config = lib.mkIf cfg.enable {
    # TODO: Add xmonad config
  };
}
