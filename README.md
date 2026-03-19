# dev-agents-setup

Cost-optimized configurations for [OpenCode](https://opencode.ai) and [Claude Code](https://claude.ai/code) that assign the right model to each agent, cutting your bill by 50-75% without sacrificing quality.

## Repository Structure

```
.
├── opencode/
│   ├── configs/
│   │   ├── anthropic.json    # Anthropic API key, Claude-only
│   │   ├── zen.json          # Zen billing, Sonnet build + free system agents
│   │   ├── zen-codex.json    # Zen billing, GPT 5.1 Codex build (~60% savings)
│   │   └── zen-ultra.json    # Zen billing, maximum savings, experimental
│   ├── switch.sh             # Switch between configs
│   └── OPENCODE_CONFIG.md    # Full rationale and cost breakdown
└── claude-code/
    ├── settings.json         # Global config → ~/.claude/settings.json
    └── agents/
        ├── plan.md           # Opus 4.6 — planning and architecture
        └── explore.md        # Haiku 4.5 — fast read-only search
```

---

## OpenCode

### Config Comparison

| Config | Build | Plan | System | Est. Savings |
|--------|-------|------|--------|-------------|
| `anthropic` | Sonnet 4.6 | Opus 4.6 | Haiku 4.5 | ~35% |
| `zen` | Sonnet 4.6 | Opus 4.6 | GPT 5 Nano (free) + Gemini Flash | ~50% |
| `zen-codex` | GPT 5.1 Codex | Opus 4.6 | GPT 5 Nano (free) + Gemini Flash | ~60% |
| `zen-ultra` | Kimi K2.5 | Gemini 3.1 Pro | GPT 5 Nano (free) + Gemini Flash | ~75% |

### Agent Model Assignments (zen — recommended)

| Agent | Model | Role |
|-------|-------|------|
| **build** | Sonnet 4.6 | Writes and edits code (Tab-switchable) |
| **plan** | Opus 4.6 | Analysis and planning without edits (Tab-switchable) |
| **general** | Sonnet 4.6 | Multi-step research, full tool access (Tab-switchable + subagent) |
| **explore** | Gemini 3 Flash | Fast read-only codebase search (Tab-switchable + subagent) |
| **title** | GPT 5 Nano | Session title generation (system, **free**) |
| **summary** | GPT 5 Nano | Session summaries (system, **free**) |
| **compaction** | Gemini 3 Flash | Context compaction (system) |

### Quick Start

Choose your config and run the switch script:

```bash
# Start here — proven models, free system agents
./opencode/switch.sh zen

# Use your Anthropic API key directly (Claude-only)
./opencode/switch.sh anthropic

# GPT 5.1 Codex for build — purpose-built for code, ~60% savings
./opencode/switch.sh zen-codex

# Maximum savings — experimental models, test before committing
./opencode/switch.sh zen-ultra
```

This copies the chosen config to `~/.config/opencode/opencode.json`. Run it any time to switch.

Launch OpenCode and press `Tab` to cycle through agents: **Build → Plan → General → Explore**.

### Upgrade Path

1. **Start with `zen`** — safe defaults, immediate savings on system agents
2. **Try `zen-codex`** after a week — GPT 5.1 Codex is purpose-built for code at ~60% savings
3. **Experiment with `zen-ultra`** on side projects — biggest savings, newer models

### Usage Tips

| Task | Best agent | Why |
|------|-----------|-----|
| Write or edit code | **Build** | Strong code gen, cheaper than Opus |
| Architecture, code review | **Plan** (Opus) | Deep reasoning where it counts |
| Research across files, fetch docs | **General** | Full tool access, multi-step capable |
| Find files, search code | **Explore** | Read-only, very cheap |

Use `@explore` or `@general` to invoke them as subagents from Build or Plan mode.

See [`opencode/OPENCODE_CONFIG.md`](opencode/OPENCODE_CONFIG.md) for full rationale, privacy details, and cost breakdown.

---

## Claude Code

### Model Assignments

| Context | Model | How |
|---------|-------|-----|
| Main session (build) | Sonnet 4.6 | Default via `settings.json` |
| `plan` subagent | Opus 4.6 | `agents/plan.md` |
| `explore` subagent | Haiku 4.5 | `agents/explore.md` |

### Quick Start

```bash
# Global settings
cp claude-code/settings.json ~/.claude/settings.json

# Custom subagents (global)
mkdir -p ~/.claude/agents
cp claude-code/agents/plan.md ~/.claude/agents/plan.md
cp claude-code/agents/explore.md ~/.claude/agents/explore.md
```

Or for per-project agents, copy into `.claude/agents/` in your project root.

### Usage Tips

Claude Code automatically delegates to the right subagent based on the task description. You can also invoke them explicitly:

- **"Use the explore agent to find..."** → runs on Haiku 4.5
- **"Use the plan agent to review..."** → runs on Opus 4.6
- **Main session** → Sonnet 4.6 for all coding work

Use `/model` inside a session to switch models on the fly when needed.

---

## Cost Model

| Model | Price (per 1M tokens) | Retention | Trains on data |
|-------|-----------------------|-----------|----------------|
| Claude Opus 4.6 | $5 in / $25 out | 30 days | No |
| Claude Sonnet 4.6 | $3 in / $15 out | 30 days | No |
| Claude Haiku 4.5 | $1 in / $5 out | 30 days | No |
| GPT 5.1 Codex | $1.07 in / $8.50 out | 30 days | No |
| GPT 5 Nano | **Free** | 30 days | No |
| Gemini 3.1 Pro | $2 in / $12 out | Zero | No |
| Gemini 3 Flash | $0.50 in / $3 out | Zero | No |
| Kimi K2.5 | $0.60 in / $3 out | Zero | No |

**Strategy:** Keep Opus only for Plan (deep reasoning, short sessions). Use code-specialized or cheaper models for Build. Use free/near-free models for system agents (title, summary, compaction) which are trivial tasks.

All models are selected to have **no training on your data**. Free models that train (Big Pickle, MiniMax Free, MiMo Free, Nemotron Free) are excluded.

## References

- [OpenCode Documentation](https://opencode.ai/docs)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [OpenCode Zen Pricing](https://opencode.ai/docs/zen)
