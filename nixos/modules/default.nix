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

    nomad = ./nomad;
    vault = ./vault;
    consul = ./consul;

    tailscale = ./tailscale;

    haproxy = ./haproxy;

    admin_ssh = ./admin_ssh.nix;

    "filesystem/zfs" = ./filesystem/zfs;

    "cloudhost/hetzner" = ./cloudhost/hetzner;

    "media" = ./media;

    postgres = ./data/postgres;
    paperless = ./paperless;
    vintagestory = ./vintagestory.nix;
  };
}
