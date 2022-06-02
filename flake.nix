{
  description = "nixos configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";
  inputs.unixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = inputs @ { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    rec {
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
      };
    };
}
