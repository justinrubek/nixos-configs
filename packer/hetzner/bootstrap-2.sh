#!/usr/bin/env bash
set -euxo pipefail

chown -R root:root /mnt/var/lib/secrets

umount /mnt/var/lib/secrets
umount /mnt/{var,nix,boot}
umount /mnt

zfs rollback -r tank/rootfs@empty
zpool export tank
