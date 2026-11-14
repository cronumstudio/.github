#!/bin/bash
# Applies a changed compose.yml to the running runners without cutting a job: recreates
# each pair (runner and its Docker) as soon as its runner is idle. Pair 2 first, so one
# runner keeps taking jobs. Waits up to an hour per pair; logs to the journal
# (journalctl -t ci-recreate). Run it detached, as the user that owns /opt/gh-runner:
#   sudo systemd-run --unit=ci-recreate --uid="$USER" --gid=docker \
#     -p WorkingDirectory=/opt/gh-runner /opt/gh-runner/recreate-when-idle.sh
set -u
cd /opt/gh-runner
# A runner with a job has a Runner.Worker process. If the check itself fails, count it
# as busy: better to wait than to cut a job.
busy() {
  local ps
  ps=$(docker top "$1" 2>/dev/null) || return 0
  grep -q Runner.Worker <<< "$ps"
}
for pair in "runner-2 dind-2 gh-runner-runner-2-1" "runner dind gh-runner-runner-1"; do
  set -- $pair
  for _ in $(seq 1 720); do busy "$3" || break; sleep 5; done
  if busy "$3"; then logger -t ci-recreate "$1 still busy after an hour, left as it was"; continue; fi
  docker compose up -d --no-build "$1" "$2" 2>&1 | logger -t ci-recreate
  logger -t ci-recreate "$1 and $2 recreated (cgroup $(docker inspect -f '{{.HostConfig.CgroupParent}}' "$3"), memory $(docker inspect -f '{{.HostConfig.Memory}}' "$3"))"
done
logger -t ci-recreate done
