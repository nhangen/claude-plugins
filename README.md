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
| ceo | Autonomous CEO agent. Reads Obsidian vault, dispatches 6 specialized subagents, 8 playbooks, 7 skills, cron execution pipeline with three-phase tier enforcement. CLI with setup/doctor/test. | `claude plugin install ceo@nhangen-tools` |
| md-scanner | Behavioral markdown documentation scanner. Analyzes session history to find gaps in CLAUDE.md, rules, memory, and project settings. Detects repeated file reads, command failures, recurring user corrections, allowlist gaps, unused CLAUDE.md sections, documented-but-still-re-read paths, and Cursor↔Claude rule drift. Guided walkthrough to approve/skip/defer recommendations. | `claude plugin install md-scanner@nhangen-tools` |
| context-loop | Auto-compact when context fill crosses thresholds. Stop-hook gate computes fill % from the live transcript; fires an advisory at 35% and escalated nudge at 50%, both directing /compact. Context-window divisor is a dynamic var (CONTEXT_LOOP_WINDOW override; falls back to Opus 1M / other 200K heuristic). | `claude plugin install context-loop@nhangen-tools` |
| gitnexus-edit-augment | PreToolUse hook that runs gitnexus impact on the symbol being edited and injects the blast-radius summary as additionalContext at the moment of editing. Companion to GitNexus's shipped Grep/Glob/Bash hook (which only covers the search phase, not the edit phase). | `claude plugin install gitnexus-edit-augment@nhangen-tools` |
| domain-glossary | Source-grounded project glossary. Auto-invokes when the agent encounters an unfamiliar acronym or project-specific term in a registered repo: resolves the current cwd to a domain via per-machine config (with git-worktree fallback), reads the matching glossary, and answers cited rather than guessing. Also handles seed (build candidates from claude-mem / commits / GitNexus / docs) and drift-check (verify every citation still resolves). | `claude plugin install domain-glossary@nhangen-tools` |
| manus-dispatch | Dispatch long-running research tasks to the Manus AI agent platform from Claude Code via slash command. SessionStart + Stop hooks surface newly-completed tasks both on next session and mid-conversation (zero extra Claude turns). On-demand polling, optional Obsidian filing, explicit-invocation cost gating. | `claude plugin install manus-dispatch@nhangen-tools` |
| pattern-tracker | Captures (features, label, evidence) tuples from Claude Code sessions as ML training data. PreToolUse/PostToolUse hooks write per-tool-call feature rows; phrase-based detector + LLM-as-judge label corrections against a failure-mode taxonomy seeded from ~/.claude/rules/. Joiner emits parquet ready for fine-tuning, DPO, or eval. Includes `pt cost-by-failure` fusion view joining findings to token-scope per-session cost. Private repo. | `claude plugin install pattern-tracker@nhangen-tools` |

## Updating

```bash
claude plugin update <name>@nhangen-tools
```

## License

MIT
