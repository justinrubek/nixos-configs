input: {
  flake.lib = {
    nixosSystem = import ./nixos_system.nix input;
  };
}
