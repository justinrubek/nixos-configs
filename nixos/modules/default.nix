{
  inputs,
  self,
  ...
} @ moduleInput: {
  # TODO: Rewrite modules to have better inputs
  flake.nixosModules = {
    cachix = import ./cachix inputs;
    nix = import ./nix.nix inputs;
    flake = import ./flake.nix inputs;
    sound = import ./sound.nix inputs;

    "graphical/fonts" = import ./graphical/fonts moduleInput;

    "windowing/hyprland" = import ./windowing/hyprland inputs;
    "windowing/river" = import ./windowing/river inputs;
    "windowing/xmonad" = import ./windowing/xmonad inputs;
    "windowing/plasma" = import ./windowing/plasma inputs;

    containers = import ./containers.nix inputs;

    nomad = import ./nomad moduleInput;
    vault = import ./vault moduleInput;
    consul = import ./consul moduleInput;

    tailscale = import ./tailscale moduleInput;

    haproxy = import ./haproxy moduleInput;

    admin_ssh = import ./admin_ssh.nix inputs;

    "filesystem/zfs" = import ./filesystem/zfs inputs;

    "cloudhost/hetzner" = import ./cloudhost/hetzner inputs;

    "media" = import ./media moduleInput;

    postgres = import ./data/postgres moduleInput;
  };
}
