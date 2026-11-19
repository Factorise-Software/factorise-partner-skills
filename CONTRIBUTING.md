# Maintaining the partner plugin

This repository is public, and is meant for partners. It's a Claude plugin marketplace,
`factorise`, with one plugin, `factorise-partner`. Nothing internal goes in: no ticket keys, no
internal hosts or names, no private repositories, nothing from the app's model.

**No docs pages go in either.** The Factorise docs are private, and git history is public too:
a page that was ever committed stays readable.

## Layout

- `plugins/factorise-partner/skills/make-demo/SKILL.md`: the skill.
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
- the pages as plain Markdown, at the paths `SKILL.md` names, such as `factorise-api/reference/limits.md`.

## Change something

- **The docs changed:** nothing to do here. The docs site rebuilds the pack, and partners get it
  with their next download.
- **The API or the app changed:** usually nothing to do here either. `SKILL.md` tells Claude that
  the pack wins over the skill on any fact about Factorise. Keep it that way: when you add a
  fact about the API to the skill, word it as an example of what to look up, not as a rule.
- **A docs page was renamed or moved, or a new page is needed:** change the pack's page list in
  the docs repository, and search `SKILL.md` for the old path. If `SKILL.md` then needs the new
  pack, raise the date in its line "If the date is before …".
- **Add a skill:** create `plugins/factorise-partner/skills/<name>/SKILL.md` and describe it in the
  README.

## Release

1. Review `git diff <last-tag>..main`. Check for anything internal:
   `grep -rnE '[A-Z]{2,6}-[0-9]{2,}' plugins/` for ticket keys, and a search for your own
   team's tools, names and project keys. Keep that list out of this repository.
2. Run `claude plugin validate .`.
3. Run the prompts in [docs/test-prompts.md](docs/test-prompts.md) against a demo environment.
4. Bump `version` in `plugins/factorise-partner/.claude-plugin/plugin.json`. Without a bump,
   partners keep the old version.
5. Push to `main`, tag the commit `factorise-partner-v<version>`, and push the tag.
6. Republish `plugins/factorise-partner` to the organization's plugin library on claude.ai: in
   Claude Code, ask Claude to "publish this plugin to the org". Colleagues add it from the library
   (`/plugin install factorise-partner@claudeai-organization-library` in Claude Code).
