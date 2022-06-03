#!/usr/bin/env sh
set -e
nix build .#workstationHome
./result/activate
