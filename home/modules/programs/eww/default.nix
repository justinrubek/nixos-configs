{
  config,
  inputs',
  lib,
  pkgs,
  ...
}: let
  cfg = config.justinrubek.programs.eww;

  dependencies = [
    config.wayland.windowManager.hyprland.package
    config.programs.eww.package
    pkgs.bash
    pkgs.bc
    pkgs.blueberry
    pkgs.bluez
    pkgs.coreutils
    pkgs.dbus
    pkgs.dunst
    pkgs.findutils
    pkgs.gawk
    pkgs.gnused
    pkgs.gojq
    pkgs.imagemagick
    pkgs.iwgtk
    pkgs.jaq
    pkgs.light
    pkgs.networkmanager
    pkgs.networkmanagerapplet
    pkgs.pavucontrol
    pkgs.playerctl
    pkgs.procps
    pkgs.pulseaudio
    pkgs.ripgrep
    pkgs.socat
    pkgs.udev
    pkgs.upower
    pkgs.util-linux
    pkgs.wget
    pkgs.wireplumber
    pkgs.wlogout
    pkgs.wofi
  ];
in {
  options.justinrubek.programs.eww = {
    enable = lib.mkEnableOption "Enable eww bars";
  };

  config = lib.mkIf cfg.enable {
    programs.eww = {
      enable = true;
      package = inputs'.eww.packages.eww-wayland;
      configDir = ./config;
    };

    systemd.user.services.eww = {
      Unit = {
        Description = "Eww Daemon";
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
