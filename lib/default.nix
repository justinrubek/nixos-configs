input @ {
  self,
  inputs,
  config,
  ...
}: let
in {
  flake.lib = {
    nixosSystem = import ./nixos_system.nix input;
  };
}
