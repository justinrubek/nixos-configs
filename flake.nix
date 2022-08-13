{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    unixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    nurpkgs = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nurpkgs,
    home-manager,
    flake-utils,
    pre-commit-hooks,
    ...
  }:
    (
      flake-utils.lib.eachDefaultSystem (system: let
        overlays = [
          inputs.neovim-nightly-overlay.overlay
        ];

        pkgs = import nixpkgs {
          inherit system;
        };

        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
          };
        };
      in rec {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [alejandra home-manager.packages.${system}.home-manager];
            inherit (pre-commit-check) shellHook;
          };
        };

        checks = {
          pre-commit = pre-commit-check;
        };
      })
    )
    // {
      lib = import ./lib inputs;

      nixosConfigurations = import ./nixos/configurations inputs;

      homeConfigurations = import ./home/configurations inputs;
    };
}
