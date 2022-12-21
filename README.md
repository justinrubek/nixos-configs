# home

This is my personal workstation and server configurations expressed as a nix flake.


## features

In addition to the workstations, the servers are configured to provide the pieces of a HashiCorp stack (currently a work in progress).

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

## secrets

Managed using [sops-nix](https://github.com/Mic92/sops-nix)

New machines need to be added to `.sops.yaml` to access secrets.
The machine's key can be determined using `ssh-to-age`:

`ssh-keyscan ${ip} | ssh-to-age`

## bootstrapping cluster

1. Provision the server using terraform

`tnix hetzner apply`


2. Active nix profiles on the newly provisioned servers

`deploy -i`


3. Initialize Vault and join all peers to cluster

Ensure VAULT_ADDR is available for all vault cli commands (since this is happening over http): `export VAULT_ADDR=http://localhost:8200` 

On a single machine, initialize Vault: `vault operator init`.
Unseal Vault using the keys: `vault operator unseal`

For each additional node, join the cluster and unseal using the same set of keys:
```
vault operator raft join http://${initial-node}:8200
vault unseal
# repeat unseal
```
