# Security policy

"Cronum Studio" and "we" mean Martin Andersen, trading as Cronum Studio, who maintains these
repositories and runs the hosted service. This policy says how to tell us about a security
problem, what happens next, and which research we authorise.

## Scope

You can report problems in:

- the code in the public repositories of the [cronumstudio](https://github.com/cronumstudio)
  organization on GitHub, whoever runs it;
- the service we host at work.cronumstudio.com, and the website cronumstudio.com;
- the addresses that lead to them: www.cronumstudio.com and the old addresses of our apps,
  tasks.cronumstudio.com, projects.cronumstudio.com, next.cronumstudio.com and
  notes.cronumstudio.com;
- the Cronum Work apps for iPhone and Android.

What you may test, and where, is narrower: see [Safe harbour](#safe-harbour).

## How to report a vulnerability

Please report it privately, never in a public issue, pull request or discussion.

1. **On GitHub (preferred):** open the affected repository, go to its **Security** tab and
   choose **Report a vulnerability**. This is GitHub's private vulnerability reporting: only
   you and the maintainers see the report, and a fix can be prepared with you in private.
2. **By email**, if you can't use GitHub, if the problem is only in the hosted service or the
   apps, or if you don't know which repository is affected: hello@cronumstudio.com, with
   "Security" in the subject.

You can write in English or Spanish.

## What to include

- The repository and version (a commit, a tag, or what the app's `/version` page shows); for
  the hosted service, the address you tested; for a phone app, its version.
- What the problem lets someone do, and to whom.
- The steps to reproduce it, ideally the smallest request, script or page that shows it.
- Whether you came across anyone else's data, and what kind and how much. Describe it; don't
  send it to us.
- Whether anyone else knows about it or it is already public.
- Whether you'd like to be credited, and under which name.

Leave other people's data, and any password, key or token, out of the report.

## What to expect

Cronum Studio is maintained by one person, so these are aims, not guarantees:

- We aim to acknowledge your report within **5 working days**.
- We tell you whether we accept it as a vulnerability, and aim to update you at least every
  **14 days** until it is resolved.
- We aim to release a fix within **90 days** of your report, sooner for serious problems.

There is no bug bounty: we don't pay for reports.

## Coordinated disclosure

Please give us **90 days** from your report before you disclose it publicly, or less if the fix
comes sooner: for a problem in the code, until its advisory is published; for a problem only in
the hosted service or the apps, until we tell you it is fixed. If a fix needs longer, we will
explain why and agree a new date with you. If the problem is being actively exploited, we may
agree with you to disclose it sooner.

When the fix is out, we publish a GitHub security advisory on the affected repository; for a
problem only in the hosted service or the apps, we tell you when it is fixed. If you asked for
credit, we credit you under the name you gave us; otherwise we don't name you.

Some problems we must also report, whatever the disclosure date: if personal data was exposed,
we may have to tell the Spanish Data Protection Agency (AEPD) and the people affected, and the
law can require us to tell other authorities. We do that without your name, unless you agree or
the law requires it.

## Safe harbour

If you research and report a vulnerability in good faith and in line with this policy:

- **we authorise that research in advance**, on the hosted service, the website, the addresses
  that lead to them and our phone apps;
- **we will not take legal action against you because of it**: no complaint to the police, a
  prosecutor or a court, and no claim for damages. We will not ask anyone else to take action
  either;
- **we will not hold it against your account**: research in line with this policy doesn't break
  our terms of service, and we won't close your account for it. We may still block traffic or a
  test account, or reset its data, to protect others while we look into it;
- **if someone else takes action against you** over research that kept to this policy, we will
  confirm, when asked, that we authorised it.

Good faith means looking for security problems to get them fixed, without harming anyone and
without seeking anything from it but credit. Asking for money or anything else in return for a
report, or for not disclosing it, is not good faith. If you go beyond this policy by mistake,
stop and tell us at once: we won't hold an honest mistake against you.

What you may do:

- **Your own copy of the code:** test it as you like. That needs no permission from us; please
  report to us what you find in the code.
- **The hosted service and the apps:** test them with accounts that are yours, or that their
  owner has let you use. You may create the test accounts you need, with email addresses that
  are yours; if you need Pro features to test, ask us. For this research you may also analyse
  and decompile our phone apps, and our own code that the service sends to your browser. That
  permission covers only our code: it doesn't set aside the app stores' terms or the licences
  of other people's code.

In return, please:

- stop as soon as you have shown the problem. If you get into one of our servers or accounts,
  go no further into it, and don't reach other systems from there;
- never change or delete data that isn't yours: show a problem between your own accounts. To
  test sharing and invitations, use email addresses that are yours, because they send real
  emails;
- if you come across someone else's data, look at no more than you need to show the problem
  and don't copy or save it: stop, tell us at once and keep it to yourself. If your tools kept
  any of it, delete it as soon as you have reported it, and tell us when you have;
- if you find a secret, such as a password, key or token, don't use it: tell us where you found
  it, and we will change it;
- don't keep any advantage the problem gives you, such as a paid plan you didn't pay for;
- don't degrade the service for others: no denial of service, and no high-volume automated
  scanning;
- don't test our GitHub workflows or bots by opening pull requests, issues or comments:
  describe the problem to us privately instead;
- give us the time described above before you disclose, and leave other people's data and any
  secrets out of what you publish.

Wherever you can, test against a copy you run yourself rather than the hosted service.

What this policy can't do: it speaks only for Cronum Studio. It can't authorise tests of
systems that others run, even when they rely on our code or their security.txt gives our
address:

- installs that other people run;
- the sign-in pages (run by WorkOS) and the checkout (run by Paddle);
- the AI assistants that connect to the service;
- the services of Cloudflare, GitHub, the app stores and our hosting and email providers.

Nor can it stop the authorities from acting on their own, or anyone whose data you reached from
acting on theirs. If you're unsure whether something is allowed, ask us first at
hello@cronumstudio.com.

## Out of scope

- Denial of service, load or stress testing.
- Social engineering or phishing of Cronum Studio, its users or its providers, and physical
  attacks.
- Testing installs that other people or organizations run: report a problem with one to
  whoever runs it. A vulnerability in the code is in scope wherever it shows, but find it in the
  code or in your own copy.
- Systems and services of the providers the hosted service relies on: report those to the
  provider. A problem in how we use them is in scope.
- Hosts under cronumstudio.com that aren't listed in the scope above: if you notice a problem
  with one, tell us, but don't test it.
- Reports from automated tools without a working proof of concept, and missing hardening
  (headers, cookie flags, email settings such as SPF or DMARC, rate limits on actions that
  aren't sensitive) with no demonstrated impact.

## Your report and your data

We use your report and your contact details to deal with the problem, to keep a record of it
and, if you want, to credit you. We keep them for two years after the problem is closed, or
longer if a legal claim needs them. We pass technical details on to a provider only when its
system is affected, and to the authorities when the law requires it, as described above; in
both cases without your name, unless you agree or the law requires it. If a report comes with a
threat or a demand, or the research went beyond this policy on purpose, we may pass the report
and your details to the police or a court. A report made on GitHub is also kept by GitHub, under
its own terms. The [privacy policy](https://cronumstudio.com/privacy/#github) explains your
rights.

## Supported versions

Fixes go into the `main` branch of each repository; older versions are not maintained
separately. If you run the code yourself, update to the latest version to get security fixes,
and watch the repository's security advisories. This policy is not a warranty or a support
contract: as its licence says, the code comes without warranty, to the extent the law allows.

## Contact and changes

The same contact is published at https://cronumstudio.com/.well-known/security.txt and
https://work.cronumstudio.com/.well-known/security.txt.

We may update this policy. A change applies only to research done after it is published here:
what you did under an earlier version is judged by that version.

Last updated: 7 December 2026.
