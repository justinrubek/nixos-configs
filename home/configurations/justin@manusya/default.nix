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
    activeProfiles = ["development"];

    home.packages = with pkgs; [
      ripgrep
      fd
      gtop
      gping
      procs
      httpie
      curlie
      duf
      zip
      unzip
      psmisc
      tectonic
      speedcrunch
      flameshot
      bitwarden
      ffmpeg
      youtube-dl
      obs-studio
      vlc
      blender
      kdenlive
      protontricks
      rofi
      gnumake
      gcc
      cargo
      rust-analyzer
      discord
      brave
      nerdfonts
      bitwarden
      neofetch
      rustc
      slack
      lagrange
      gimp
      teamspeak_client
      openscad
      scrcpy
      zoom-us
      protontricks
    ];

    # programs.firefox = import ./programs/firefox {inherit pkgs username;};
    programs.ufirefox = {
      enable = true;
      username = username;
    };

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
