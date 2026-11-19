# Maintaining the partner plugin

This repository is public, and is meant for partners. It's a Claude plugin marketplace,
`factorise`, with one plugin, `factorise-partner`. Nothing internal goes in: no ticket keys, no
internal hosts or names, no private repositories, nothing from the app's model.

**No docs pages go in either.** The Factorise docs are private, and git history is public too:
a page that was ever committed stays readable.

## Layout

- `plugins/factorise-partner/skills/make-demo/SKILL.md`: what counts in every part of a demo (the
  ground rules, the docs, how to call the API) and part 1, the interview.
- `…/make-demo/references/connect.md`, `build.md`, `handover.md`: parts 2 to 4. Claude reads each
  when it starts that part.
- `…/make-demo/scripts/get-docs-*`: download and unpack the docs pack, for Mac and Windows.
- `…/make-demo/scripts/connect-*`: the pop-ups that save the partner's login.
- `docs/test-prompts.md`: what to try before a release.

## The docs pack

The skill reads the docs from a pack that the docs site builds and serves behind its login:
`https://docs.factorise-suite.com/downloads/factorise-docs-pack.zip`. The partner's own browser
downloads it, so the docs site's login decides who gets it. The scripts download a new one when the partner's
copy is more than 14 days old. They expect:

- one top folder, `factorise-docs-pack/`;
- in it `pack.json`, such as `{"format": 1, "built": "2026-11-17"}`. Raise `format` only for a
  change old plugin versions can't read: they then ask the partner to update;
- `INDEX.md`, listing each page with its address on the site;
- the pages as plain Markdown. The skill names pages by their title and finds the file through
  `INDEX.md`, so a page can move without a change here.

## Where things go

- **How Factorise works goes in the docs, not here.** What the API can create, a field name, a
  load order, what an answer means: Claude looks those up in the pack, and the skill says the
  pack wins. A fact copied into the skill is out of date at the next release of Factorise. When
  the skill needs to mention one, word it as an example of what to look up.
- **How to run a demo project goes in the skill:** the conversation, what makes a demo convincing,
  what to keep apart in a shared environment, every yes, and the ground rules.
- **`SKILL.md` stays under 18,000 characters** (`wc -c`). In a long session Claude Code keeps only
  about the first 5,000 tokens of a skill, and a build is a long session. So `SKILL.md` holds
  only what every part needs, in the order in which losing it would hurt: the ground rules and
  the API command first, the interview last, because it's over first. Parts 2 to 4 have their
  own files, which Claude reads when it starts a part and again when it needs them.
- **One place per rule.** A rule that holds in every part goes in `SKILL.md`. Anything else goes
  in the file of the part where Claude acts on it.

## Change something

- **The docs changed, or a page moved:** nothing to do here. The docs site rebuilds the pack, and
  partners get it with their next download.
- **The API or the app changed:** usually nothing to do here either, for the reason above.
- **A docs page got a new title, or was split or removed:** search the skill's files for the old
  title.
- **Add a skill:** create `plugins/factorise-partner/skills/<name>/SKILL.md` and describe it in the
  README.

## Release

1. Review `git diff <last-tag>..main`. Check for anything internal:
   `grep -rnE '[A-Z]{2,6}-[0-9]{2,}' plugins/` for ticket keys, and a search for your own
   team's tools, names and project keys. Keep that list out of this repository.
2. Run `claude plugin validate .`.
3. Run the prompts in [docs/test-prompts.md](docs/test-prompts.md) against a demo environment.
   Read the transcript as well as the result: a question the partner didn't need, or a fact
   Claude took from the skill instead of the docs, is something to cut.
4. Bump `version` in `plugins/factorise-partner/.claude-plugin/plugin.json`. Without a bump,
   partners keep the old version.
5. Push to `main`, tag the commit `factorise-partner-v<version>`, and push the tag.
6. Republish `plugins/factorise-partner` to the organization's plugin library on claude.ai: in
   Claude Code, ask Claude to "publish this plugin to the org". Colleagues add it from the library
   (`/plugin install factorise-partner@claudeai-organization-library` in Claude Code).
