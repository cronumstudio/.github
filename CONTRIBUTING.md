# Contributing to Cronum Studio

Thank you for helping. These repositories hold Cronum Work, its modules and the platform they
share, published under the GNU Affero General Public License v3.0 (AGPL-3.0-only). Cronum Studio
also runs them as a hosted service.

Cronum Studio is maintained by one person. Reading this first saves your time as much as ours.

## Which repository

| Repository | What it holds |
| --- | --- |
| [work](https://github.com/cronumstudio/work) | Cronum Work, the app people run: the shell that hosts the modules, its server, the Docker image and self-hosting. |
| [tasks](https://github.com/cronumstudio/tasks), [projects](https://github.com/cronumstudio/projects), [next](https://github.com/cronumstudio/next), [notes](https://github.com/cronumstudio/notes) | One module of Cronum Work each: its pages, its API, its tools for AI assistants and its translations. |
| [suite-core](https://github.com/cronumstudio/suite-core) | The platform the modules share: accounts and sign-in, sharing, settings, the MCP and OAuth endpoints, the web kit. |
| [.github](https://github.com/cronumstudio/.github) | These community files and the shared CI workflows. |

If you're not sure where something belongs, open the issue in work; it will be moved if needed.

## Issues first

- A typo, a broken link or a small, obvious bug fix: open a pull request directly.
- Anything else (a new feature, a change in behaviour, a refactor, a new file format): open an
  issue first and wait for an answer, so the approach is agreed before you put in the work. A
  pull request that arrives without that may be closed, even a good one, if it doesn't fit.

For a bug, say what you did, what you expected and what happened, and which version you were
on (the app's `/version` page, or the commit).

## Setting up

You need Node.js 24 or later and git. There are no npm dependencies and no build step.

```sh
git clone --recurse-submodules https://github.com/cronumstudio/<repository>.git
cd <repository>
npm test
```

`--recurse-submodules` matters: work and every module include suite-core at `server/suite`, and
work also includes the four modules under `modules/`. If you cloned without it, run
`git submodule update --init --recursive`. Where the repository's `package.json` has an `i18n`
script, also run `npm run i18n`: it checks that every translation catalog has the same keys,
placeholders and plural forms. How to start the app locally is in each repository's README.

## Pull requests

A good pull request:

- is small and focused: one change, with what it does and why in its description, and a link
  to the issue it comes from;
- follows the conventions: suite-core's
  [CONVENTIONS.md](https://github.com/cronumstudio/suite-core/blob/main/CONVENTIONS.md), which
  every repository follows, and the repository's own `CLAUDE.md`, which describes its
  architecture, rules and tests (it is written for coding agents, and is just as useful to
  people);
- comes with tests for what it changes, and `npm test` passes;
- is in English: code, comments, commit messages and documentation. Text people see in the app
  goes into the translation catalogs, never into the code;
- adds no npm dependency. If something seems to need one, ask in an issue first.

CI runs the tests, a secret scan and the CLA check on every pull request.

## Contributor License Agreement

Before a pull request can be merged, its author signs the
[Contributor License Agreement](https://github.com/cronumstudio/.github/blob/main/CLA.md). You keep
the copyright of your work. The agreement lets Cronum Studio keep the projects open and also offer
them as a hosted service. Please read it before you sign.

The CLA Assistant bot asks once per repository: on your first pull request in each repository of
the organization, it comments with a link to the agreement, and you sign by replying with this
exact comment:

```text
I have read the CLA Document and I hereby sign the CLA
```

It is the same agreement in every repository. If the check doesn't turn green after you sign,
comment `recheck`.

## Reviews

Reviews are best effort. We try to give a first answer to new issues and pull requests within
two weeks; it can take longer around releases and holidays. If you've heard nothing after that,
a short comment on the thread is welcome.

## Security and support

- **Security problems:** never in a public issue or pull request. See the
  [security policy](https://github.com/cronumstudio/.github/blob/main/SECURITY.md).
- **Problems with an account on the hosted service** (sign-in, plan, payments, your data): by
  email, not in an issue. See [support](https://github.com/cronumstudio/.github/blob/main/SUPPORT.md).

## Code of conduct

Everyone who takes part follows the
[code of conduct](https://github.com/cronumstudio/.github/blob/main/CODE_OF_CONDUCT.md).
