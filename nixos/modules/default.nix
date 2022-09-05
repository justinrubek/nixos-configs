inputs: {
  cachix = import ./cachix inputs;
  nix = import ./nix.nix inputs;
  flake = import ./flake.nix inputs;
}
