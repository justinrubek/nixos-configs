{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    unixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unixpkgs";
    };

    nurpkgs = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    nixvim.url = "github:pta2002/nixvim";
  };

  outputs = {
    self,
    flake-utils,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit self;} {
      flake = {
        lib = import ./lib inputs;

        nixosConfigurations = import ./nixos/configurations inputs;

        homeConfigurations = import ./home/configurations inputs;
        homeModules = import ./home/modules inputs;
      };
      systems = flake-utils.lib.defaultSystems;
      imports = [
        ./flake-parts
      ];
    };
}
