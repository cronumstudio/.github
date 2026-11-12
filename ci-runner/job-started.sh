#!/bin/bash
# Before every job: leave the CI as a fresh GitHub machine would be.
# Workflows written for ubuntu-latest create fixed names (a container `app`,
# a volume `app-data`) and never clean up, because their machine is thrown
# away. This only reaches the dind daemon, never the server's own Docker.
docker ps -aq | xargs -r docker rm -f >/dev/null
docker volume prune -af >/dev/null
docker network prune -f >/dev/null
docker image prune -af --filter until=72h >/dev/null
docker builder prune -af --filter until=72h >/dev/null

# The runner's own container and volumes are on the production server's disk,
# and it keeps what GitHub's machines throw away: the temporary folders tests
# leave behind (thousands), the npm cache, the runner's logs and the package
# of its last self-update. On 12/11 that and dind's build cache had taken
# 22 GB and left the disk with 0 bytes free. Nothing here is a job's work: a
# job's temporary folders are younger than six hours, and an update unpacks
# between jobs, never while this runs.
find /tmp -mindepth 1 -maxdepth 1 -mmin +360 -exec rm -rf {} + 2>/dev/null
find /home/runner/_diag -type f -mtime +3 -delete 2>/dev/null
npm_cache=/home/runner/.npm/_cacache
if [ -d "$npm_cache" ] && [ "$(du -sm "$npm_cache" | cut -f1)" -gt 500 ]; then
  rm -rf "$npm_cache"
fi
find /home/runner/_work/_update -maxdepth 0 -mmin +1440 -exec rm -rf {} + 2>/dev/null

# Production goes first: with less than 8 GB free on the disk, CI's own Docker
# is emptied whatever the age of what it holds (the next build is slower, the
# apps keep room to write).
free_gb=$(( $(df --output=avail -k /home/runner/_work | tail -1) / 1048576 ))
if [ "$free_gb" -lt 8 ]; then
  docker system prune -af --volumes >/dev/null
  free_gb=$(( $(df --output=avail -k /home/runner/_work | tail -1) / 1048576 ))
  echo "Low disk: CI Docker emptied."
fi
echo "CI Docker cleaned: no containers or volumes from earlier jobs. Disk: ${free_gb} GB free."
exit 0
