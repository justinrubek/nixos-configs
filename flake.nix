{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    unixpkgs.url = "nixpkgs/nixos-unstable";

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

  outputs = inputs @ { self, nixpkgs, nurpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
    in
    rec {
      homeConfigurations = (
        import ./home-conf.nix {
	        inherit system nixpkgs nurpkgs home-manager;
            inherit overlays;
	    }
      );

      nixosConfigurations = {
        workstation = nixpkgs.lib.nixosSystem {
	        inherit system;
	        specialArgs = { inherit inputs; };
	        modules = [
                ./configuration.nix
                ./machine/manusya
            ];
        };
      };

      packages.x86_64-linux = {
	    workstation = nixosConfigurations.workstation.config.system.build.toplevel;
	    workstationHome = homeConfigurations.main.activationPackage;
      };
    };
}
