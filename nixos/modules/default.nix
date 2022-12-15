{
  inputs,
  self,
  ...
}: let
  # TODO: Rewrite modules to have better inputs
  moduleInput = {
    inherit inputs self;
  };
in {
  flake.nixosModules = {
    cachix = import ./cachix inputs;
    nix = import ./nix.nix inputs;
    flake = import ./flake.nix inputs;
    sound = import ./sound.nix inputs;

    "windowing/xmonad" = import ./windowing/xmonad inputs;
    "windowing/plasma" = import ./windowing/plasma inputs;

    containers = import ./containers.nix inputs;
    nomad = import ./nomad moduleInput;

    admin_ssh = import ./admin_ssh.nix inputs;

    "filesystem/zfs" = import ./filesystem/zfs inputs;

    "cloudhost/hetzner" = import ./cloudhost/hetzner inputs;
  };
}
