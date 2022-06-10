# home

This is my personal workstation configuration expressed as a nix flake.
It is currently a work in progress and may become quite specific to me,
but I am leaving this open to allow others to gather insight on how to make a similar setup.
The road to learning (and making use of) nix has been long and the documentation quite scarce, so I will appreciate any advice offered in the form of an issue/PR.

I originally wanted to make use of [digga](https://github.com/divnix/digga) but the project is fairly complex, out of date, and severely lacking in documentation. I will be keeping a close eye on that and potentially contributing to it or making a project in my own vision to accomplish my goals.

## Getting started

There are two types of configurations exported: one for NixOS and one for home-manager.
Most of the configuration will live on the home-manager side, but it is useful for me to have both together.

The first thing to remember is that the configuration in this repository is my personal one.
Especially for the NixOS configuration where it even has options that are specify to my hardware.
You will need to modify this somewhat to use it.
I'd like to include more instructions on how to do so, and potentially some better abstractions to make the configurations more agnostic.

The main dependency needed is [nix](https://nixos.org/download.html).
You will likely need to [configure it to use flakes](https://nixos.wiki/wiki/Flakes#Installing_flakes)

### home-manager

You should be able to apply this configuration to any machine.
In order to do so you must build the configuration and run the activation script.
```bash
nix build .#workstationHome
result/activate
```
A script has been provided that does this: `switchHome.sh`

#### features

- neovim configured with lsp and a number of productivity features/controls
- firefox with extensions pre-installed
- a number of cli and gui tools for daily use

### NixOS

This configuration is meant to be applied to a fresh install of NixOS.
Follow the regular installer to create partitions.
Then, place your `hardware-configuration.nix` into the machines directory and use that in place of `manusya`.
Afterwards you can switch your configuration:
```bash
nix build .#workstation
sudo result/bin/switch-to-configuration switch
```

## inspiration/helping hands

https://gvolpe.com/blog/nix-flakes/
