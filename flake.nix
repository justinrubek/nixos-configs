{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nurpkgs.url = "github:nix-community/NUR";

    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";

    thoenix = {
      url = "github:justinrubek/thoenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comma = {
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-nomad = {
      url = "github:tristanpemble/nix-nomad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/hyprland";

    conduit = {
      url = "github:justinrubek/conduit";
    };

    gpt-toolkit = {
      url = "github:justinrubek/gpt-toolkit";
    };

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    project-runner = {
      url = "github:justinrubek/project-runner";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lockpad = {
      url = "github:justinrubek/lockpad";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit self;} {
      flake = {
        homeModules = import ./home/modules inputs;
      };
      systems = ["x86_64-linux" "aarch64-linux"];
      imports = [
        inputs.thoenix.flakeModule
        inputs.thoenix.customOutputModule

        ./flake-parts/devshell
        ./flake-parts/packages
        ./flake-parts/ci.nix

        ./containers
        ./packages

        ./lib

        ./modules

        ./flake-parts/nixos_configurations.nix
        ./nixos/configurations
        ./nixos/modules

        ./flake-parts/home_configurations.nix
        ./home/configurations

        ./deploy

        ./flake-parts/terraform.nix
        ./flake-parts/terraformConfiguration.nix
        ./terraform/modules

        ./nomad
      ];
    };
}
