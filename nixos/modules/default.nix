{
  inputs,
  self,
  ...
} @ moduleInput: {
  flake.nixosModules = {
    cachix = ./cachix;
    nix = ./nix.nix;
    flake = ./flake.nix;
    sound = ./sound.nix;

    "graphical/fonts" = ./graphical/fonts;

    "windowing/hyprland" = ./windowing/hyprland;
    "windowing/river" = ./windowing/river;
    "windowing/xmonad" = ./windowing/xmonad;
    "windowing/plasma" = ./windowing/plasma;

    containers = ./containers.nix;

    tailscale = ./tailscale;

    "filesystem/zfs" = ./filesystem/zfs;

    "media" = ./media;

    postgres = ./data/postgres;
    paperless = ./paperless;
  };
}
