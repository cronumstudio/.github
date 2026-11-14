# The organisation's own runners

Two self-hosted GitHub Actions runners, `hetzner-ci` and `hetzner-ci-2`, for
cronumstudio's private repositories, on the production server (`cronum-prod`,
Hetzner) in `/opt/gh-runner`. Runners of our own don't spend the plan's Actions
minutes.

Both carry the label `hetzner`: GitHub hands each queued job to whichever is
free, so a pull request's jobs run two at a time, and a job waits only when
both are busy. Nothing is assigned by hand.

## How it is isolated

The server runs production, so the runners are kept apart from it, as far as a
shared machine allows:

- **Its own Docker.** Each runner's jobs talk to a Docker daemon of their own
  (`dind`, `dind-2`), not the server's. They can't see, stop or remove the
  apps' containers, volumes or images, and the fixed names our workflows use
  (`app`, `app-data`) can't clash with anything real or with the other
  runner's job. Each pair has its own network, where its daemon answers over
  TLS as `docker`: no port is published.
- **Caps.** Each runner has 1 CPU and 640 MB, each Docker 1.5 CPU and 1 GB,
  all with a quarter of the normal CPU weight. Under load production goes
  first, and a runaway build is what gets killed. Measured with both busy: a
  pair peaks at about 500 MB, and the server kept over 1.5 GB free.
- **A clean start for every job.** `job-started.sh` removes, in the runner's
  own Docker, the containers, volumes and networks left by earlier jobs, and images and build cache older
  than three days, as on a fresh GitHub machine. In the runner itself it removes
  what a fresh machine wouldn't have either: the temporary folders tests leave
  in `/tmp` (older than six hours), the runner's logs older than three days,
  the npm cache once it passes 500 MB and the package of the last self-update.
- **A disk of its own.** Everything a job can fill (each runner's home with its npm
  cache, logs and self-updates, the workspace, `/tmp`, and each Docker's images and build
  cache) is on `/srv/ci`, a 14 GB file system in a file (`/var/lib/gh-runner/ci.img`,
  sparse: it takes only what CI uses). When it is full, CI fails and production, on the
  server's own disk, doesn't notice: on 11 and 12/11 CI had taken 22 GB and left that disk
  with 0 bytes. With less than 3 GB free on `/srv/ci`, `job-started.sh` empties the CI's
  own Docker and the npm cache whatever their age, and every job's log says how much is
  free ("CI disk: N GB free"). `ci-disk.sh` creates it.
- **Nothing carried between jobs that could change them.** `job-completed.sh` removes the
  actions and tools (`_work/_actions`, `_work/_tool`) each job downloaded, so a job of one
  repository can't leave a changed action or Node for the next. What this does not do:
  a job still controls a privileged Docker (`dind`) on the production server, and with
  it the server. Only code from these repositories and the actions they pin by commit
  runs here; moving the runners to a server of their own would close it, and was decided
  against on 14/11/2026 (6/11 audit, deps-ci-1).
- **Private repositories only.** The organisation's default runner group
  doesn't take public repositories, and the workflows only send private ones
  here: a pull request from a fork of a public repository never runs on the
  server.

## Turning it on and off

The reusable workflows pick the runner with the variable `CI_RUNNER`, set on
each private repository (Settings → Secrets and variables → Actions →
Variables). On GitHub Free an organisation variable doesn't reach private
repositories, so it has to be the repository's own:

```bash
gh variable set CI_RUNNER -R cronumstudio/<repo> --body hetzner   # here
gh variable delete CI_RUNNER -R cronumstudio/<repo>               # GitHub's machines
```

It is set on every private repository. Only the jobs
that come from these shared workflows move: a repository's own jobs with
`runs-on: ubuntu-latest` stay on GitHub until they use the same expression,
and tracker's `macos-15` job can't run here at all.

The runner takes jobs even while the plan's included minutes are used up:
they don't count against them.

## Installing them again

On the server, with these files in `/opt/gh-runner`:

```bash
cd /opt/gh-runner
docker compose build
sudo bash ci-disk.sh                # the CI's own disk at /srv/ci (safe to run again)
# a registration token, valid for an hour, from an organisation owner
# (one token registers both runners):
#   gh api -X POST orgs/cronumstudio/actions/runners/registration-token --jq .token
echo "RUNNER_TOKEN=<token>" > .env && chmod 600 .env
docker compose up -d
docker compose logs -f runner runner-2   # "Listening for Jobs"
: > .env                          # the token is no longer needed
```

Each runner keeps its credentials in its `state` volume, so rebuilding or
updating the containers doesn't need a new token. They update themselves when GitHub
publishes a new version; `docker compose pull && docker compose up -d --build`
brings the images up to date.

A runner's home is on `/srv/ci` and comes from the image only the first time, so a
rebuilt image changes the hooks in `/usr/local/bin` but not the runner in the home (it
updates itself). To start a runner from a new image: stop it, empty
`/srv/ci/disk/home` (or `home-2`) and run `ci-disk.sh` again.

A new `job-started.sh` or `job-completed.sh` reaches the running containers without
rebuilding them (the next rebuild takes them from `/opt/gh-runner`); only while neither
runs a job, since it removes the CI's containers:

```bash
cd /opt/gh-runner
for c in gh-runner-runner-1 gh-runner-runner-2-1; do
  for f in job-started.sh job-completed.sh; do
    docker cp "$f" "$c:/usr/local/bin/$f"
    docker exec -u root "$c" chmod 755 "/usr/local/bin/$f"
  done
done
```

If the runners are down or full for long, every private repository can go back to
GitHub's machines at once (and back again with `--body hetzner`); they use the plan's
minutes while there:

```bash
for r in $(gh repo list cronumstudio --visibility private --json name --jq '.[].name'); do
  gh variable delete CI_RUNNER -R cronumstudio/$r
done
```

To remove them: `docker compose down -v` on the server, `umount /srv/ci`, delete the
`/srv/ci` line from `/etc/fstab` and `/var/lib/gh-runner/ci.img`, and delete `hetzner-ci`
and `hetzner-ci-2` under Settings → Actions → Runners.
