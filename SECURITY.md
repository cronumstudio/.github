# Security policy

## Scope

This policy covers:

- the code in every repository of the [cronumstudio](https://github.com/cronumstudio)
  organization on GitHub, wherever it runs, including on someone's own server;
- the service Cronum Studio hosts at work.cronumstudio.com and cronumstudio.com.

## How to report a vulnerability

Please report it privately, never in a public issue, pull request or discussion.

1. **On GitHub (preferred):** open the affected repository, go to its **Security** tab and
   choose **Report a vulnerability**. This is GitHub's private vulnerability reporting: only
   you and the maintainers see the report, and a fix can be prepared with you in private.
2. **By email**, if you can't use GitHub, if the problem is only in the hosted service, or if
   you don't know which repository is affected: hello@cronumstudio.com, with "Security" in
   the subject.

## What to include

- The repository and version (a commit, a tag, or what the app's `/version` page shows), or,
  for the hosted service, the address you tested.
- What the problem lets someone do, and to whom.
- The steps to reproduce it, ideally the smallest request, script or page that shows it.
- Whether anyone else knows about it or it is already public.
- How you'd like to be credited, if at all.

## What to expect

Cronum Studio is maintained by one person, so these are targets, not guarantees:

- We acknowledge your report within **5 working days**.
- We tell you whether we accept it as a vulnerability, and keep you updated at least every
  **14 days** until it is resolved.
- We aim to release a fix within **90 days** of your report, sooner for serious problems.

There is no paid bug bounty.

## Coordinated disclosure

Please give us **90 days** from your report before you disclose it publicly, or until a fix
is released, whichever comes first. If a fix needs longer, we will explain why and agree a new
date with you. If the problem is being actively exploited, we may both agree to disclose
sooner.

When the fix is out, we publish a GitHub security advisory on the affected repository and
credit you, unless you prefer not to be named.

## Safe harbour

If you research and report a vulnerability in good faith and in line with this policy, we
consider your research authorised, and we will not take legal action against you, or ask
anyone else to, because of it. In return, please:

- use only accounts you own, or have permission to use, and stop as soon as you have shown
  the problem;
- not access, change, keep or share other people's data beyond the minimum needed to show
  the problem, and tell us if you came across any;
- not degrade the service for others: no denial of service, and no high-volume automated
  scanning of the hosted service;
- give us the time described above before you disclose.

Wherever you can, test against a copy you run yourself rather than the hosted service. This
policy can only speak for Cronum Studio: it can't authorise tests of systems run by anyone
else. If you're unsure whether something is allowed, ask us first at the address above.

## Out of scope

- Denial of service, load or stress testing.
- Social engineering or phishing of Cronum Studio, its users or its providers, and physical
  attacks.
- Copies of the code that other people or organizations run themselves: report problems with
  those to whoever runs them. A vulnerability in the code itself is in scope, whoever runs it.
- Services of other providers that the hosted service relies on: report those to the
  provider. A problem in how we use them is in scope.
- Reports from automated tools without a working proof of concept, and missing hardening
  (headers, cookie flags, rate limits on actions that aren't sensitive) with no demonstrated
  impact.

## Supported versions

Fixes go into the `main` branch of each repository; older versions are not maintained
separately. If you run the code yourself, update to the latest version to get security fixes,
and watch the repository's security advisories.

The same contact is published at https://cronumstudio.com/.well-known/security.txt.
