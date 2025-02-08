{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.media;
in {
  options.profiles.media = {
    enable = lib.mkEnableOption "media profile";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vlc
      yt-dlp
      feishin
      pkgs.ffmpeg-full
      pkgs.mkvtoolnix
    ];

    programs.mpv.enable = true;
  };
}
