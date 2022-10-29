inputs: {
  cachix = import ./cachix inputs;
  nix = import ./nix.nix inputs;
  flake = import ./flake.nix inputs;
  sound = import ./sound.nix inputs;

  "windowing/xmonad" = import ./windowing/xmonad inputs;
  "windowing/plasma" = import ./windowing/plasma inputs;

  containers = import ./containers.nix inputs;
}