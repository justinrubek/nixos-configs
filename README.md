# home

This is my personal workstation and some server configurations expressed as a nix flake.
Previously this repository contained all of my infrastructure configuration; this has been changed so that most of the configuration is separated.


## features

- neovim configured with lsp and a number of other plugins and personal preferences
- firefox with extensions pre-installed
- a number of cli and gui tools for daily use
    - There is a concept of `profiles` in home-manager configurations that captures my commonly used ones



## applying nixos/home configurations

### manually

`nh os switch --ask .`

`nh home switch --ask .`

### raspberry pi

- build the image: `nix build .#nixosConfigurations.rpi5.config.system.build.sdImage`
- decompress (to `rpi-image`): `zstd --decompress result/sd-image/nixos-sd-image-24.11.20240529.ad57eef-aarch64-linux.img.zst -o rpi-image`
- use `dd` to write the image to an sd card: `sudo dd if=rpi-image of=/dev/sdX bs=4M`
- remotely apply nixos-configuration: `nixos-rebuild switch --flake .#rpi5 --target-host rpi5`

## secrets

### [sops-nix](https://github.com/Mic92/sops-nix)

New machines need to be added to `.sops.yaml` to access secrets.
The machine's key can be determined using `ssh-to-age`:

`ssh-keyscan ${ip} | ssh-to-age`

#### adding a new secret

Create an entry in `.sops.yaml` specifying the file (or use a pattern of some sort for multiple) and the keys that are allowed to access it.
Then edit the file: `sops secrets/filename.yaml`
