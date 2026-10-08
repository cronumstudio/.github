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

The reusable workflows pick the runner with the organisation variable
`CI_RUNNER` (Settings → Secrets and variables → Actions → Variables):

- `CI_RUNNER` = `hetzner`: private repositories run here.
- Variable removed: everything goes back to GitHub's `ubuntu-latest`.

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
