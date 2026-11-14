#!/bin/bash
# Gives the CI a disk of its own on the production server: a 14 GB ext4 file system in a
# file, mounted at /srv/ci. compose.yml puts everything a job can fill there (runners'
# home, workspace, /tmp, each Docker's data), so CI can never take the disk production
# writes to: on 11 and 12 Nov 2026 it filled it to 0 bytes. The file is sparse: it only
# takes on the server's disk what CI really uses, up to 14 GB, and gives back what CI
# deletes (discard).
#
# Run as root from /opt/gh-runner, with the runners stopped (`docker compose down`).
# Safe to run again: it creates only what is missing. SIZE changes only a new disk.
set -euo pipefail
IMG=/var/lib/gh-runner/ci.img
MNT=/srv/ci
SIZE=${SIZE:-14G}
IMAGE=gh-runner:local

mkdir -p "$(dirname "$IMG")" "$MNT"
if [ ! -f "$IMG" ]; then
  truncate -s "$SIZE" "$IMG"
  mkfs.ext4 -q -m 0 -L gh-runner-ci "$IMG"
fi
# nofail: if it can't be mounted the server still boots; the CI containers then fail to
# start, because their volumes point inside /srv/ci/disk, which only exists on this disk.
grep -q "^$IMG " /etc/fstab || echo "$IMG $MNT ext4 loop,discard,nofail 0 2" >> /etc/fstab
mountpoint -q "$MNT" || mount "$MNT"

for d in home work tmp dind home-2 work-2 tmp-2 dind-2; do mkdir -p "$MNT/disk/$d"; done
chmod 1777 "$MNT/disk/tmp" "$MNT/disk/tmp-2"
chown 1001:1001 "$MNT/disk/work" "$MNT/disk/work-2"
# The runner's home comes from the image the first time (its own copy of the runner, which
# then updates itself there). To start one from a new image, empty its folder and run this.
for d in home home-2; do
  if [ -z "$(ls -A "$MNT/disk/$d")" ]; then
    docker run --rm --user root --entrypoint sh -v "$MNT/disk/$d:/mnt" "$IMAGE" \
      -c 'cp -a /home/runner/. /mnt/ && chown 1001:1001 /mnt'
  fi
done
df -h "$MNT"
