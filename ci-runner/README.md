# The organisation's own runner

A self-hosted GitHub Actions runner for cronumstudio's private repositories, on
the production server (`cronum-prod`, Hetzner) in `/opt/gh-runner`. Runners of
our own don't spend the plan's Actions minutes.

## How it is isolated

The server runs production, so the runner is kept apart from it:

- **Its own Docker.** Jobs talk to a Docker daemon of their own (`dind`), not
  the server's. They can't see, stop or remove the apps' containers, volumes or
  images, and the fixed names our workflows use (`app`, `app-data`) can't clash
  with anything real. The daemon answers over TLS on the compose network only:
  no port is published.
- **Caps.** The runner has 1 CPU and 768 MB, its Docker 1.5 CPU and 1.28 GB,
  both with a quarter of the normal CPU weight. Under load production goes
  first, and a runaway build is what gets killed.
- **A clean start for every job.** `job-started.sh` removes the containers,
  volumes and networks left by earlier jobs, and images and build cache older
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

## Installing it again

On the server, with these files in `/opt/gh-runner`:

```bash
cd /opt/gh-runner
# a registration token, valid for an hour, from an organisation owner:
#   gh api -X POST orgs/cronumstudio/actions/runners/registration-token --jq .token
echo "RUNNER_TOKEN=<token>" > .env && chmod 600 .env
docker compose up -d --build
docker compose logs -f runner     # "Listening for Jobs"
: > .env                          # the token is no longer needed
```

The runner keeps its credentials in the `state` volume, so rebuilding or
updating the containers doesn't need a new token. It updates itself when GitHub
publishes a new version; `docker compose pull && docker compose up -d --build`
brings the images up to date.

To remove it: `docker compose down -v` on the server, and delete `hetzner-ci`
under Settings → Actions → Runners.
