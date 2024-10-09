_: {
  flake.homeModules = {
    "profiles" = ./profiles;
    "profiles/base" = ./profiles/base;
    "profiles/development" = ./profiles/development;
    "profiles/browsing" = ./profiles/browsing;
    "profiles/gaming" = ./profiles/gaming;
    "profiles/work" = ./profiles/work;
    "profiles/media" = ./profiles/media;
    "profiles/design" = ./profiles/design;
    "profiles/graphical" = ./profiles/graphical;

    "programs/firefox" = ./programs/firefox;
    "programs/pijul" = ./programs/pijul;

    "wayland/common" = ./wayland/common;
    "wayland/swaylock" = ./wayland/swaylock;

    "windowing/xmonad" = ./windowing/xmonad;
    "windowing/hyprland" = ./windowing/hyprland;
    "windowing/river" = ./windowing/river;

    # always runs for every configuration
    "misc/home" = ./misc/home;
  };
}
