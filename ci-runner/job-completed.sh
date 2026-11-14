#!/bin/bash
# After every job: the actions and tools it downloaded are not left for the next one. Two
# runners take jobs from every private repository, so one repository's job could otherwise
# leave a changed action or Node behind for the next, which may carry other secrets (6/11
# audit, deps-ci-1). Fetching them again takes seconds. Not in job-started.sh: by the time
# that runs, the runner has already downloaded the job's actions.
# The runner runs this as `bash --noprofile --norc -e -o pipefail`; nothing here may fail.
rm -rf /home/runner/_work/_actions /home/runner/_work/_tool 2>/dev/null || true
exit 0
