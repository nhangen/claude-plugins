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

### claude-mem-graph

Causal tracing layer over claude-mem. Use flat search to find an observation, then use graph neighbors to trace what led to it and what followed.

```bash
claude plugin install claude-mem-graph@nhangen-tools
```

- Extracts `informed_by` edges from observation narrative text (1,300+ causal edges)
- Cross-project keyword search across all observation fields
- Session arc tracking (which sessions continue previous work)
- File history across projects
- Usage analytics via `npm run stats`

**Repo:** [nhangen/claude-mem-graph](https://github.com/nhangen/claude-mem-graph)

### ceo

Autonomous CEO agent. Reads Obsidian vault, dispatches specialized subagents, executes playbooks on a cron schedule with three-phase tier enforcement.

```bash
claude plugin install ceo@nhangen-tools
```

- 7 playbooks, 7 skills, 6 agent roles
- Cron execution pipeline with delegation protocol
- Reads vault for context, writes decisions back

**Repo:** [nhangen/claude-ceo](https://github.com/nhangen/claude-ceo)

### md-scanner

Behavioral markdown documentation scanner. Finds gaps in CLAUDE.md, rules, and memory by analyzing what actually happens during sessions.

```bash
claude plugin install md-scanner@nhangen-tools
```

- Stop hook tags each session with structured extracts (file reads, bash errors, user messages, tool sequences)
- `/md-scanner` skill correlates patterns across sessions and recommends specific additions
- Routes to the right surface: project CLAUDE.md, global CLAUDE.md, rules, memory, or skill candidates
- Guided walkthrough: approve, skip, edit, defer each recommendation
- Cross-references token-scope (bloat), RTK (command failures), and claude-mem (concepts)

**Repo:** [nhangen/md-scanner](https://github.com/nhangen/md-scanner)

## Usage

After installing a plugin, its skills, hooks, and commands are available in Claude Code automatically. Run `claude plugin list` to see installed plugins.

## License

MIT
