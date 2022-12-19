# home

This is my personal workstation and server configurations expressed as a nix flake.


## features

- packer images for NixOS on a cloud host
- terraform configuration to provision cloud VMs from a base image and other infrastructure
- [deploy-rs](https://github.com/serokell/deploy-rs) for managing nixos and home-manager configurations
- patched [nomad](https://github.com/hashicorp/nomad) that can run nix flakes using the docker driver
- neovim configured with lsp and a number of other plugins and personal preferences
- firefox with extensions pre-installed
- a number of cli and gui tools for daily use
    - There is a concept of `profiles` in home-manager configurations that captures my commonly used ones


Most custom configuration is exposed as nix modules and can be accessed by the flake outputs
`nixosModules`, `homeModules`, and `modules` (for nixos/home agnostic modules).


## applying nixos/home configurations

### manually

`sudo nixos-rebuild switch --flake .`

`home-manager switch --flake .`

### deploy-rs

Deployment configuration contained in `./deploy`

## terraform

[thoenix](https://github.com/justinrubek/thoenix) is included and a `tnix` script is in the devShell which can run terraform commands:

`tnix hetzner init`

`tnix hetzner plan`
