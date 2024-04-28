{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    hashicorp_nixpkgs.url = "github:nixos/nixpkgs/f91ee3065de91a3531329a674a45ddcb3467a650";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";

    terranix = {
      url = "github:justinrubek/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    thoenix = {
      url = "github:justinrubek/thoenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        terranix.follows = "terranix";
        fenix.follows = "fenix";
      };
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

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    conduit = {
      url = "github:justinrubek/conduit";
    };

    generation-toolkit = {
      url = "github:justinrubek/generation-toolkit";
    };
    ghlink = {
      url = "github:matthewdargan/ghlink";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-prune-branches = {
      url = "github:justinrubek/git-prune-branches";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fenix.follows = "fenix";
    };

    nix-postgres = {
      url = "github:justinrubek/nix-postgres";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    project-runner = {
      url = "github:justinrubek/project-runner";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fenix.follows = "fenix";
    };

    lockpad = {
      url = "github:justinrubek/lockpad";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        fenix.follows = "fenix";
      };
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    global-keybind = {
      url = "github:justinrubek/global-keybind";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fenix.follows = "fenix";
    };

    gitu = {
      url = "github:altsem/gitu";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fenix.follows = "fenix";
    };
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        homeModules = import ./home/modules inputs;
      };
      systems = ["x86_64-linux" "aarch64-linux"];
      imports = [
        inputs.thoenix.flakeModule
        inputs.thoenix.customOutputModule

        ./flake-parts/shells.nix
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

        ./flake-parts/pre-commit.nix
        ./flake-parts/formatting.nix
        inputs.pre-commit-hooks.flakeModule
      ];
    };
}
