{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    cam2ip = {
      url = "github:justinrubek/cam2ip";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    config-parts = {
      url = "github:justinrubek/config-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    neovim-config = {
      # url = "github:justinrubek/neovim-config/8f8281a24ebab665f6e755db4727df4bd5e8b852";
      url = "github:justinrubek/neovim-config";
      inputs = {
        fenix.follows = "fenix";
        nix-go.follows = "nix-go";
        nixpkgs.follows = "nixpkgs";
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

    hyprland = {
      url = "git+https://github.com/hyprwm/hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "git+https://github.com/hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "git+https://github.com/hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    generation-toolkit = {
      url = "github:justinrubek/generation-toolkit";
    };
    ghlink = {
      url = "github:matthewdargan/ghlink";
      inputs = {
        fenix.follows = "fenix";
        nixpkgs.follows = "nixpkgs";
      };
    };
    git-bare = {
      url = "github:justinrubek/git-bare";
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

    epify = {
      url = "github:matthewdargan/epify";
      inputs.nixpkgs.follows = "nixpkgs";
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
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-go = {
      url = "github:matthewdargan/nix-go";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    raspberry-pi-nix.url = "github:tstat/raspberry-pi-nix";
    sftpgo = {
      url = "github:justinrubek/sftpgo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm.url = "github:wez/wezterm?dir=nix";
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];
      imports = [
        ./flake-parts/ci.nix
        ./flake-parts/pre-commit.nix
        ./flake-parts/shells.nix
        ./home/configurations
        ./home/modules
        ./nixos/configurations
        ./nixos/modules
        ./packages
      ];
    };
}
