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

### [sops-nix](https://github.com/Mic92/sops-nix)

New machines need to be added to `.sops.yaml` to access secrets.
The machine's key can be determined using `ssh-to-age`:

`ssh-keyscan ${ip} | ssh-to-age`

### vault

#### tips

`export VAULT_ADDR=http://127.0.0.1:8200`

`vault kv get --mount=kv-v2 secret/hello`


## bootstrapping cluster

0. Pre-setup

In order to access the machines that are going to be provisioned an SSH key has to be provided to the `justinrubek.administration` module.
This will be the key used for deploying NixOS configurations to the machines.
Particularly, the setting must be configured for the base image so that the desired configuration will be applied to the correct host.
Beyond that each host may have their own configuration which differs from this.

A base image must exist so that terraform can provision the machines.
Currently there is only a generator included for Hetzner Cloud: `cd packer/hetzner/ && HCLOUD_TOKEN=token packer build main.pkr.hcl`
This will create a new server in rescue mode, switch it with NixOS, and create a snapshot.
The image ID will need to be specified in the terraform configuration.
Find it using `hcloud image list --type snapshot`, noting the `ID` field.


1. Provision the server using terraform

`tnix hetzner apply`


2. Active nix profiles on the newly provisioned servers

The base image doesn't have tailscale configured, so the addresses will have to be specified manually at this point.
Change the deployment configuration so that each node that is newly created from the base image has an address from which it can be accessed via SSH.
Once a machine is configured with tailscale this is not needed, but can still remain as is.

Additionally, new servers should have their key added to `.sops.yaml` at this point.
The files we need re-processed to ensure the newly added keys can access them: `sops updatekeys ${secretsFile}`.

Finally, build and push the configuration to the servers: `deploy -i`


3. Initialize Vault and join all peers to cluster

Ensure VAULT_ADDR is available for all vault cli commands (since this is happening over http): `export VAULT_ADDR=http://localhost:8200` 

SSH into one of the machines and initialize Vault: `vault operator init`.
Unseal Vault using the keys: `vault operator unseal`

For each additional node, join the cluster and unseal using the same set of keys:
```
export VAULT_ADDR=http://localhost:8200
vault operator raft join http://${initial-node}:8200
vault operator unseal
# repeat unseal until done
```
4. Join Consul peers to cluster

Repeat this step for each peer to be in the cluster.
It's enough to just provide the hostname to Consul, no protocol needed: `consul join bunky`.
Note: these have been given `retry_join` configuration, so this may not be needed.

Assuming that everything has gone correctly, Nomad should automatically bootstrap its cluster using Consul once this is done.

5. Configure Vault and Consul

Terraform configuration is provided to configure Vault: `tnix vault init && tnix vault apply`.

Additionally, the `consul` configuration is provided to allow Vault to manage Consul ACLs: `tnix consul init && tnix consul apply`.

See the following guides for information on how this was set up:

https://developer.hashicorp.com/consul/tutorials/security/access-control-setup-production#bootstrap-the-acl-system

https://www.hashicorp.com/blog/managing-hashicorp-consul-access-control-lists-with-terraform-and-vault
