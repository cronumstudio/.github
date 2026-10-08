#!/bin/bash
# Registers the runner the first time (with RUNNER_TOKEN, valid for an hour)
# and keeps its credentials in /state, so a rebuilt container goes on as the
# same runner without a new token.
set -euo pipefail
cd /home/runner
files=(.runner .credentials .credentials_rsaparams)

if [ -f /state/.runner ]; then
  for f in "${files[@]}"; do cp "/state/$f" .; done
else
  : "${RUNNER_TOKEN:?RUNNER_TOKEN is needed for the first registration}"
  ./config.sh --unattended --replace \
    --url "$RUNNER_URL" --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" --labels "$RUNNER_LABELS" \
    --runnergroup Default --work /home/runner/_work
  for f in "${files[@]}"; do cp "$f" /state/; done
fi

unset RUNNER_TOKEN
exec ./run.sh
