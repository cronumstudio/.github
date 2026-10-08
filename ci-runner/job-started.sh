#!/bin/bash
# Before every job: leave the CI Docker as a fresh GitHub machine would be.
# Workflows written for ubuntu-latest create fixed names (a container `app`,
# a volume `app-data`) and never clean up, because their machine is thrown
# away. This only reaches the dind daemon, never the server's own Docker.
docker ps -aq | xargs -r docker rm -f >/dev/null
docker volume prune -af >/dev/null
docker network prune -f >/dev/null
docker image prune -af --filter until=72h >/dev/null
docker builder prune -af --filter until=72h >/dev/null
echo "CI Docker cleaned: no containers or volumes from earlier jobs."
exit 0
