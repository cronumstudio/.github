# Contributing to Cronum Studio

Thank you for helping. These repositories hold Cronum Work, its modules and the platform they
share. Their code is published under the GNU Affero General Public License v3.0
(AGPL-3.0-only): see the LICENSE and NOTICE.md files of each code repository. Cronum Studio
also runs it as a hosted service.

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
  every repository follows, and the repository's own `CLAUDE.md` where it has one, which
  describes its architecture, rules and tests (it is written for coding agents, and is just as
  useful to people);
- comes with tests for what it changes, and `npm test` passes;
- is in English: code, comments, commit messages and documentation. Text people see in the app
  goes into the translation catalogs, never into the code;
- adds no npm dependency. If something seems to need one, ask in an issue first.

Your commits are public, with the name and email address they carry. To keep your address
private, commit with the noreply address GitHub gives you (Settings → Emails).

CI runs the tests, a secret scan and the CLA check on every pull request.

## Code from elsewhere, and AI assistants

**Code, icons, fonts or images you didn't make** come in only under one of these licences, and
only when the pull request says where they come from, which version and under which licence:

- code: MIT, ISC, BSD-2-Clause, BSD-3-Clause, Apache-2.0, 0BSD, Unlicense or CC0;
- fonts: SIL Open Font License 1.1;
- icons and images: CC BY 4.0 or CC0.

Never GPL, AGPL, LGPL, MPL, EPL, EUPL, CC BY-SA, SSPL or BUSL, nor anything "non-commercial" or
without a licence, even when that licence is compatible with the AGPL. The CLA lets Cronum Studio
run contributions in its hosted service next to parts it doesn't publish: those licences would
oblige it to publish those parts or set conditions it doesn't take on, and material without a
licence, or only for non-commercial use, can't be used there at all. Keep the material's copyright
and licence notices, and add it to the repository's `THIRD_PARTY_NOTICES.md`.

**AI assistants** may help you write a contribution. You still answer for all of it, as for
anything you send:

- read, understand and test every line before you open the pull request; one that looks generated
  and not reviewed may be closed;
- say in the pull request which tool you used and for what, and in a commit where it wrote a
  substantial part, add a trailer such as `Assisted-by: <tool and model>`; keep `Co-authored-by`
  for people;
- check that what it wrote doesn't copy code from another project; if it does, leave that out, or
  treat it as code from elsewhere (above);
- use only tools whose terms let you contribute their output under the CLA;
- don't give a tool anything you may not share: secrets, other people's personal data, or code you
  hold in confidence.

Signing the CLA covers what an AI assistant helped you write, as it covers the rest: you confirm
that you have the right to submit it.

## Contributor License Agreement

Before a pull request can be merged, every author of its commits signs the
[Contributor License Agreement](https://github.com/cronumstudio/.github/blob/main/CLA.md) (CLA).
You keep the copyright of your work. The agreement gives Cronum Studio a free license to use your
contribution in the open projects and also under other licenses, including closed ones, for
example in its hosted service. Please read it before you sign.

The CLA Assistant bot asks once per repository: on your first pull request in each repository of
the organization, it comments with a link to the agreement, and you sign by replying with this
exact comment:

```text
I have read the Cronum Studio CLA version 1.1 and I hereby sign it
```

It is the same agreement in every repository. If the check doesn't turn green after you sign,
comment `recheck`. When there is a new version of the CLA, the bot asks you to sign it on your
next pull request; what you contributed before stays under the version you signed then.

- When you sign, the bot records your GitHub username and user ID, the date, and the numbers of
  your comment, of the pull request and of the repository in that repository's `cla-signatures`
  branch, where anyone can see it. Our [privacy policy](https://cronumstudio.com/privacy/#github)
  explains how we handle that record and how to object to it being public.
- Code that someone else wrote goes in a commit of their own, so that the bot asks them to sign
  too.
- If you contribute as part of your job, or your employer may own what you write, write to
  hello@cronumstudio.com before you sign: your employer signs the
  [corporate CLA](https://github.com/cronumstudio/.github/blob/main/CORPORATE-CLA.md), and you sign
  the CLA as well.
- If you are not yet of legal age (18 in most countries), don't sign yet: write to
  hello@cronumstudio.com first. A parent or legal guardian has to agree to the CLA for you in
  writing; then you sign it too.

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
[code of conduct](https://github.com/cronumstudio/.github/blob/main/CODE_OF_CONDUCT.md). To report
behaviour that breaks it, email hello@cronumstudio.com with "Conduct" in the subject.
