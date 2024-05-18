{
  inputs,
  self,
  ...
}: {
  flake.homeModules = {
    "profiles" = import ./profiles inputs;
    "profiles/base" = import ./profiles/base inputs;
    "profiles/development" = import ./profiles/development inputs;
    "profiles/browsing" = import ./profiles/browsing inputs;
    "profiles/gaming" = import ./profiles/gaming inputs;
    "profiles/work" = import ./profiles/work inputs;
    "profiles/media" = import ./profiles/media inputs;
    "profiles/design" = import ./profiles/design inputs;
    "profiles/graphical" = import ./profiles/graphical inputs;

    "programs/firefox" = import ./programs/firefox inputs;
    "programs/pijul" = import ./programs/pijul inputs;

    "wayland/common" = import ./wayland/common inputs;
    "wayland/swaylock" = import ./wayland/swaylock inputs;

    "windowing/xmonad" = import ./windowing/xmonad inputs;
    "windowing/hyprland" = import ./windowing/hyprland inputs;
    "windowing/waybar" = import ./windowing/waybar inputs;

    # always runs for every configuration
    "misc/home" = import ./misc/home inputs;
  };
}
