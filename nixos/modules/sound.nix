{
  config,
  lib,
  ...
}: let
  cfg = config.justinrubek.sound;
in {
  options.justinrubek.sound = {
    enable = lib.mkEnableOption "enable sound";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;

      pulse.enable = true;
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    hardware.pulseaudio.enable = false;
    security.rtkit.enable = lib.mkDefault true;
  };
}
