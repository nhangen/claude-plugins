# claude-plugins (nhangen-tools marketplace)

This repo is a marketplace index only. `.claude-plugin/marketplace.json` lists the
plugins, and each entry's `source.repo` points at the `nhangen/*` repo that holds the
code. Never add plugin code here. Find a plugin's local source in
`~/.config/branch-cleanup/repos.md`; most live under `~/ML-AI/claude/`. Look the
directory up there rather than guessing it: it can match neither the plugin nor the repo
name (`obsidian` from `claude-obsidian-plugin` lives in `obsidian-plugin/`).

## Bumping a plugin version

1. Release in the source repo first. Its `.claude-plugin/plugin.json` `version` must be
   on the default branch.
2. Set `.plugins[].version` in `marketplace.json` to match. If the description changed,
   update the README table too.
3. Commit as `<plugin>: bump marketplace entry to X.Y.Z (<one-line reason>)`.

## Gotchas

- `.github/workflows/sync-versions.yml` runs every 6 hours and commits to `main`. It
  overwrites each `version` with the source repo's `plugin.json`, so a marketplace bump
  that lands before the source release gets reverted: `2fa3248` took context-loop from
  0.1.4 back to 0.1.3. Fetch before editing, because the bot may have moved `main`.
- The bot's token can't read the private repos `nhangen/gitnexus-edit-augment` and
  `nhangen/cc-pattern-tracker`, so bump those two by hand. `EXPECTED_UNREADABLE` in
  `scripts/sync-versions.sh` logs them as `skip:`. Any other unreadable repo logs `fail:`
  with the `gh` error and turns the run red; add a plugin to that list only if its repo
  is private.
- Check for drift locally with `bash scripts/sync-versions.sh --dry-run` (needs `gh` and
  `jq`).
