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
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];

      pkgs = import nixpkgs {inherit system;};

      pre-commit = import pre-commit-hooks {inherit system;};
    in rec {
      homeConfigurations = (
        import ./home-conf.nix {
          inherit system nixpkgs nurpkgs home-manager;
          inherit overlays;
        }
      );

      nixosConfigurations = {
        workstation = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs;};
          modules = [
            ./configuration.nix
            ./machine/manusya
          ];
        };
      };

      packages = {
        workstation = nixosConfigurations.workstation.config.system.build.toplevel;
        workstationHome = homeConfigurations.main.activationPackage;
      };

      devShells = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [alejandra];
        };
      };

      checks = {
        pre-commit = pre-commit.lib.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
          };
        };
      };
    });
}
