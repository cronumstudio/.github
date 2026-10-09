# The organisation's own runners

Two self-hosted GitHub Actions runners, `hetzner-ci` and `hetzner-ci-2`, for
cronumstudio's private repositories, on the production server (`cronum-prod`,
Hetzner) in `/opt/gh-runner`. Runners of our own don't spend the plan's Actions
minutes.

Both carry the label `hetzner`: GitHub hands each queued job to whichever is
free, so a pull request's jobs run two at a time, and a job waits only when
both are busy. Nothing is assigned by hand.

## How it is isolated

The server runs production, so the runners are kept apart from it:

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
  than three days, as on a fresh GitHub machine.
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

It is set on next, notes, projects, tasks, tracker and work. Only the jobs
that come from these shared workflows move: a repository's own jobs with
`runs-on: ubuntu-latest` stay on GitHub until they use the same expression,
and tracker's `macos-15` job can't run here at all.

The runner takes jobs even while the plan's included minutes are used up:
they don't count against them.

## Installing them again

On the server, with these files in `/opt/gh-runner`:

```bash
cd /opt/gh-runner
# a registration token, valid for an hour, from an organisation owner
# (one token registers both runners):
#   gh api -X POST orgs/cronumstudio/actions/runners/registration-token --jq .token
echo "RUNNER_TOKEN=<token>" > .env && chmod 600 .env
docker compose up -d --build
docker compose logs -f runner runner-2   # "Listening for Jobs"
: > .env                          # the token is no longer needed
```

Each runner keeps its credentials in its `state` volume, so rebuilding or
updating the containers doesn't need a new token. They update themselves when GitHub
publishes a new version; `docker compose pull && docker compose up -d --build`
brings the images up to date.

To remove them: `docker compose down -v` on the server, and delete
`hetzner-ci` and `hetzner-ci-2` under Settings → Actions → Runners.
