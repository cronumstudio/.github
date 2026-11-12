#!/bin/bash
# Before every job: leave the CI as a fresh GitHub machine would be.
# The runner runs this hook as `bash --noprofile --norc -e -o pipefail`: any
# command that fails, here or in a pipe, fails the job before its first step.
# The Docker cleanup below may do that (a job without its Docker would fail
# anyway); the disk cleanup after it never must, so each of its commands ends
# in `|| true`.
#
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
# between jobs, never while this runs. What can't be removed (a folder of
# another user's in /tmp) stays, and the job goes on.
find /tmp -mindepth 1 -maxdepth 1 -mmin +360 -exec rm -rf {} + 2>/dev/null || true
find /home/runner/_diag -type f -mtime +3 -delete 2>/dev/null || true
npm_cache=/home/runner/.npm/_cacache
npm_mb=$(du -sm "$npm_cache" 2>/dev/null | cut -f1) || npm_mb=0
if [ "${npm_mb:-0}" -gt 500 ] 2>/dev/null; then
  rm -rf "$npm_cache" || true
fi
if [ -d /home/runner/_work/_update ]; then
  find /home/runner/_work/_update -maxdepth 0 -mmin +1440 -exec rm -rf {} + 2>/dev/null || true
fi

# Production goes first: with less than 8 GB free on the disk, CI's own Docker
# is emptied whatever the age of what it holds (the next build is slower, the
# apps keep room to write). If the free space can't be read, nothing is emptied
# and the log says so.
free_gb() {
  local kb
  kb=$(df --output=avail -k /home/runner/_work 2>/dev/null | tail -1 | tr -d ' ') || kb=
  case "$kb" in
    '' | *[!0-9]*) echo '?' ;;
    *) echo $(( kb / 1048576 )) ;;
  esac
}
free=$(free_gb)
if [ "$free" != '?' ] && [ "$free" -lt 8 ]; then
  docker system prune -af --volumes >/dev/null || true
  free=$(free_gb)
  echo "Low disk: CI Docker emptied."
fi
echo "CI Docker cleaned: no containers or volumes from earlier jobs. Disk: ${free} GB free."
exit 0
