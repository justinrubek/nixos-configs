{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.design;
in {
  options.profiles.design = {
    enable = lib.mkEnableOption "design profile";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      blender
      gimp
      kdePackages.kdenlive
      openscad-unstable
      prusa-slicer
    ];
  };
}
