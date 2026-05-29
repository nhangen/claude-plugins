# nhangen-tools

Claude Code plugin marketplace for nhangen's personal and team plugins.

## Install

```bash
claude plugin marketplace add nhangen/claude-plugins
```

## Plugins

| Name | Description | Install |
|---|---|---|
| obsidian | Obsidian vault integration for Claude Code. Auto-capture git commits, save sessions, query past work with /recall, export conversations. Supports user-defined VAULT.md conventions. | `claude plugin install obsidian@nhangen-tools` |
| token-scope | Token spend analytics and cost alerts for Claude Code. 15 report modes including cache intelligence, tooling analysis by layer, per-artifact Write/Edit cost analytics, auto-checkpoint hook for session cost control. | `claude plugin install token-scope@nhangen-tools` |
| claude-mem-graph | Causal tracing layer over claude-mem. Extracts informed_by edges from observation narratives to trace what led to what. Cross-project search, session arc tracking, file history. 5 MCP tools, 10 edge types. | `claude plugin install claude-mem-graph@nhangen-tools` |
| ceo | Autonomous CEO agent. Reads Obsidian vault, dispatches 6 specialized subagents, 8 playbooks, 7 skills, cron execution pipeline with three-phase tier enforcement. CLI with setup/doctor/test. | `claude plugin install ceo@nhangen-tools` |
| md-scanner | Behavioral markdown documentation scanner. Analyzes session history to find gaps in CLAUDE.md, rules, memory, and project settings. Detects repeated file reads, command failures, recurring user corrections, allowlist gaps, unused CLAUDE.md sections, documented-but-still-re-read paths, and Cursor↔Claude rule drift. Guided walkthrough to approve/skip/defer recommendations. | `claude plugin install md-scanner@nhangen-tools` |
| context-loop | Auto-checkpoint and /compact when context fill crosses thresholds. Stop-hook gate computes fill % from the live transcript; clean-context subagent produces a verbatim Live State brief; brief is pinned through /compact and written to durable storage. Keeps live conversation perpetually under ~40% fill. | `claude plugin install context-loop@nhangen-tools` |
| gitnexus-edit-augment | PreToolUse hook that runs gitnexus impact on the symbol being edited and injects the blast-radius summary as additionalContext at the moment of editing. Companion to GitNexus's shipped Grep/Glob/Bash hook (which only covers the search phase, not the edit phase). | `claude plugin install gitnexus-edit-augment@nhangen-tools` |
| domain-glossary | Source-grounded project glossary. Auto-invokes when the agent encounters an unfamiliar acronym or project-specific term in a registered repo: resolves the current cwd to a domain via per-machine config (with git-worktree fallback), reads the matching glossary, and answers cited rather than guessing. Also handles seed (build candidates from claude-mem / commits / GitNexus / docs) and drift-check (verify every citation still resolves). | `claude plugin install domain-glossary@nhangen-tools` |
| manus-dispatch | Dispatch long-running research tasks to the Manus AI agent platform from Claude Code via slash command. SessionStart hook surfaces newly-completed tasks on the next session (zero extra Claude turns). On-demand polling, optional Obsidian filing, explicit-invocation cost gating. | `claude plugin install manus-dispatch@nhangen-tools` |

## Updating

```bash
claude plugin update <name>@nhangen-tools
```

## License

MIT
