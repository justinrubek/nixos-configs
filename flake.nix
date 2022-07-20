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
      url = "github:nix-community/home-manager?ref=release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
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

        pkgs = import nixpkgs {inherit system;};

        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
          };
        };
      in rec {
        homeConfigurations = (
          import ./home-conf.nix {
            inherit system nixpkgs nurpkgs home-manager;
            inherit overlays;
          }
        );

        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [alejandra];
            inherit (pre-commit-check) shellHook;
          };
        };

        checks = {
          pre-commit = pre-commit-check;
        };
      })
    )
    // {
      nixosConfigurations = {
        manusya = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [
            ./configuration.nix
            ./machine/manusya
          ];
        };
      };
    };
}
