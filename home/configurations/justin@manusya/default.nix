{
  unixpkgs,
  nurpkgs,
  self,
  ...
} @ inputs: {
  pkgs,
  username,
  ...
}: let
in {
  config = {
    xdg.enable = true;
    fonts.fontconfig.enable = true;

    profiles.base.enable = true;
    activeProfiles = ["development" "browsing" "gaming"];

    home.packages = with pkgs; [
      fd
      gtop
      gping
      procs
      duf
      zip
      unzip
      psmisc
      speedcrunch
      flameshot
      bitwarden
      ffmpeg
      youtube-dl
      obs-studio
      vlc
      blender
      kdenlive
      rofi
      brave
      nerdfonts
      bitwarden
      neofetch
      slack
      lagrange
      gimp
      scrcpy
      zoom-us
    ];

    programs.fzf.enable = true;
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    programs.mpv.enable = true;

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    services.syncthing = {
      enable = true;
      tray.enable = true;
    };
    programs.pandoc.enable = true;
  };
}
