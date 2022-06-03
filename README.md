# home

This is my personal workstation configuration expressed as a nix flake.
It is currently a work in progress and may become quite specific to me,
but I am leaving this open to allow others to gather insight on how to make a similar setup.
The road to learning (and making use of) nix has been long and the documentation quite scarce, so I will appreciate any advice offered in the form of an issue/PR.

I originally wanted to make use of [digga](https://github.com/divnix/digga) but the project is fairly complex, out of date, and severely lacking in documentation. I will be keeping a close eye on that and potentially contributing to it or making a project in my own vision to accomplish my goals.

## usage

There are two configurations exported: one for nixos and one for home-manager.

### nixos
```bash
nix build .#workstation
sudo result/bin/switch-to-configuration switch
```

### home-manager
```bash
nix build .#workstationHome
result/activate
```

A script has been provided: `switchHome.sh`

## inspirational help

https://gvolpe.com/blog/nix-flakes/
