{
  description = "nixos configuration";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-22.05";
    unixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs.follows = "unixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unixpkgs";
    };

    nurpkgs.url = "github:nix-community/NUR";

    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    nixvim.url = "github:pta2002/nixvim";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nixinate.url = "github:matthewcroughan/nixinate";

    comma = {
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-utils,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit self;} {
      flake = {
        nixosModules = import ./nixos/modules inputs;

        homeModules = import ./home/modules inputs;

        modules = import ./modules inputs;
      };
      systems = ["x86_64-linux" "aarch64-linux"];
      imports = [
        ./flake-parts
        ./flake-parts/nixos_configurations.nix
        ./flake-parts/home_configurations.nix

        ./nixos/configurations
        ./home/configurations
      ];
    };
}
