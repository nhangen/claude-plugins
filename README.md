# nhangen Claude Code Plugins

Custom plugins for [Claude Code](https://claude.ai/claude-code).

## Install

```bash
claude plugin marketplace add nhangen/claude-plugins
```

## Plugins

### obsidian

Obsidian vault integration for Claude Code. Auto-capture git commits, save sessions, query past work, export conversations.

```bash
claude plugin install obsidian@nhangen-tools
```

- Auto-captures git commit context to Obsidian vault notes
- Session summarizer saves conversation context on session end
- `/recall` skill queries past work across sessions
- Configurable vault routing for multi-vault setups

**Repo:** [nhangen/claude-obsidian-plugin](https://github.com/nhangen/claude-obsidian-plugin)

### token-scope

Token spend analytics and cost alerts for Claude Code. Answers: where is my money going, and am I wasting it?

```bash
claude plugin install token-scope@nhangen-tools
```

- 10 report modes: summary, tool drill-down, sessions, project, cache efficiency, context bloat, session efficiency, thinking analysis, tooling by layer
- Cost alert hook warns when sessions get expensive
- Auto-checkpoint saves session context when cost thresholds are crossed
- All reports support `--json` for machine-readable output
- Proportional cost attribution across all tool layers (plugin, MCP, skill, meta, built-in)

**Repo:** [nhangen/token-scope](https://github.com/nhangen/token-scope)

## Usage

After installing a plugin, its skills, hooks, and commands are available in Claude Code automatically. Run `claude plugin list` to see installed plugins.

## License

MIT
