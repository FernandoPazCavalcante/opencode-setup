# OpenCode Configuration - Cost Optimization Strategy

## Config Location

Global config: `~/.config/opencode/opencode.json`

## Available Configs

| Config | Build Agent | Plan Agent | Est. Savings vs all-Opus |
|--------|-------------|------------|--------------------------|
| `anthropic` | Claude Sonnet 4.6 | Claude Opus 4.6 | ~35% |
| `zen` | Claude Sonnet 4.6 | Claude Opus 4.6 | ~50% (recommended) |
| `zen-codex` | GPT 5.1 Codex | Claude Opus 4.6 | ~60% |
| `zen-ultra` | Kimi K2.5 | Gemini 3.1 Pro | ~75% |

---

## Agent Model Assignments

### `anthropic` — Claude-only (Anthropic API key)

| Agent | Model | Role | Cost (per 1M tokens) |
|-------|-------|------|---------------------|
| **build** | Claude Sonnet 4.6 | Primary - code generation & edits | $3 in / $15 out |
| **plan** | Claude Opus 4.6 | Primary - analysis without edits | $5 in / $25 out |
| **general** | Claude Sonnet 4.6 | Primary + Subagent - research & multi-step tasks | $3 in / $15 out |
| **explore** | Claude Haiku 4.5 | Primary + Subagent - read-only codebase search | $1 in / $5 out |
| **title** | Claude Haiku 4.5 | System - session title generation | $1 in / $5 out |
| **summary** | Claude Haiku 4.5 | System - session summary | $1 in / $5 out |
| **compaction** | Claude Haiku 4.5 | System - context compaction | $1 in / $5 out |

**Note:** Compaction downgraded from Sonnet to Haiku — the only cost improvement available within the Claude family.

---

### `zen` — Sonnet build, free system agents (Zen billing, recommended)

| Agent | Model | Role | Cost (per 1M tokens) |
|-------|-------|------|---------------------|
| **build** | Claude Sonnet 4.6 | Primary - code generation & edits | $3 in / $15 out |
| **plan** | Claude Opus 4.6 | Primary - analysis without edits | $5 in / $25 out |
| **general** | Claude Sonnet 4.6 | Primary + Subagent - research & multi-step tasks | $3 in / $15 out |
| **explore** | Gemini 3 Flash | Primary + Subagent - read-only codebase search | $0.50 in / $3 out |
| **title** | GPT 5 Nano | System - session title generation | **Free** |
| **summary** | GPT 5 Nano | System - session summary | **Free** |
| **compaction** | Gemini 3 Flash | System - context compaction | $0.50 in / $3 out |

---

### `zen-codex` — GPT Codex build (~50% cheaper, Zen billing)

| Agent | Model | Role | Cost (per 1M tokens) |
|-------|-------|------|---------------------|
| **build** | GPT 5.1 Codex | Primary - code generation & edits | $1.07 in / $8.50 out |
| **plan** | Claude Opus 4.6 | Primary - analysis without edits | $5 in / $25 out |
| **general** | GPT 5.1 Codex | Primary + Subagent - research & multi-step tasks | $1.07 in / $8.50 out |
| **explore** | Gemini 3 Flash | Primary + Subagent - read-only codebase search | $0.50 in / $3 out |
| **title** | GPT 5 Nano | System - session title generation | **Free** |
| **summary** | GPT 5 Nano | System - session summary | **Free** |
| **compaction** | Gemini 3 Flash | System - context compaction | $0.50 in / $3 out |

---

### `zen-ultra` — Maximum savings, experimental models (Zen billing)

| Agent | Model | Role | Cost (per 1M tokens) |
|-------|-------|------|---------------------|
| **build** | Kimi K2.5 | Primary - code generation & edits | $0.60 in / $3 out |
| **plan** | Gemini 3.1 Pro | Primary - analysis without edits | $2 in / $12 out |
| **general** | GPT 5.1 Codex | Primary + Subagent - research & multi-step tasks | $1.07 in / $8.50 out |
| **explore** | Gemini 3 Flash | Primary + Subagent - read-only codebase search | $0.50 in / $3 out |
| **title** | GPT 5 Nano | System - session title generation | **Free** |
| **summary** | GPT 5 Nano | System - session summary | **Free** |
| **compaction** | Gemini 3 Flash | System - context compaction | $0.50 in / $3 out |

**Note:** `zen-ultra` uses Kimi K2.5 and Gemini 3.1 Pro which are newer and less battle-tested for coding. Recommended for experimentation. Fall back to `zen` or `zen-codex` if quality is insufficient.

---

## Step Limits

| Agent | Max Steps | Reason |
|-------|-----------|--------|
| **explore** | 10 | Read-only searches should be fast |
| **general** | 15 | Research tasks capped to avoid runaway costs |

---

## Compaction Settings

All configs include:

```json
"compaction": {
  "auto": true,
  "prune": true,
  "reserved": 10000
}
```

- `prune: true` — removes old tool outputs from context before compaction, directly reducing token spend
- `reserved: 10000` — leaves a 10k token buffer to prevent overflow during compaction

---

## Explore Agent Permissions

All configs restrict the explore agent from writing or running arbitrary commands:

```json
"permission": {
  "edit": "deny",
  "bash": {
    "*": "deny",
    "git *": "allow",
    "grep *": "allow",
    "find *": "allow",
    "cat *": "allow",
    "ls *": "allow"
  }
}
```

---

## Privacy Policy

All models used across these configs follow a **no training on your data** policy:

| Model | Retention | Trains on data |
|-------|-----------|----------------|
| Claude (all) | 30 days | No |
| GPT 5 Nano, GPT 5.1 Codex | 30 days | No |
| Gemini 3 Flash, Gemini 3.1 Pro | Zero retention | No |
| Kimi K2.5 | Zero retention | No |

Free models that train on data (Big Pickle, MiniMax Free, MiMo Free, Nemotron Free) are **intentionally excluded** from all configs.

---

## Rationale

- **Build (Sonnet 4.6 / GPT 5.1 Codex / Kimi K2.5):** Build produces the most output tokens. Sonnet is 40% cheaper than Opus. GPT 5.1 Codex is purpose-built for code at 64% cheaper input than Sonnet. Kimi K2.5 is experimental but dramatically cheaper with zero retention.
- **Plan (Opus 4.6 / Gemini 3.1 Pro):** Architecture and planning benefit from the deepest reasoning. Planning sessions are input-heavy with short outputs, so the premium is lower-impact. `zen-ultra` substitutes Gemini 3.1 Pro at 60% lower cost.
- **General (Sonnet 4.6 / GPT 5.1 Codex):** Multi-step research with full tool access. Sonnet handles this well. Codex is a capable alternative at lower cost.
- **Explore (Gemini 3 Flash):** Read-only file search. Gemini 3 Flash is highly capable at $0.50/$3 — 50% cheaper than Haiku and with zero data retention.
- **Title/Summary (GPT 5 Nano):** Trivial system tasks. GPT 5 Nano is free, has no training policy, and is more than sufficient for generating 5-word titles and short summaries.
- **Compaction (Gemini 3 Flash):** Context summarization. Gemini Flash handles summarization well at 83% cheaper input than Sonnet, with zero data retention.

---

## Estimated Savings

Assuming system/subagents consume ~40% of total tokens:

| Config | vs all-Opus baseline | vs original setup |
|--------|---------------------|-------------------|
| `anthropic` | ~35% savings | +4% |
| `zen` | ~50% savings | +20% |
| `zen-codex` | ~60% savings | +30% |
| `zen-ultra` | ~75% savings | +45% |

---

## Usage Tips

1. **Start with `zen`** — proven models, free system agents, safe defaults
2. **Switch to `zen-codex`** after a week if build quality is acceptable — GPT 5.1 Codex is purpose-built for code
3. **Test `zen-ultra` on non-critical projects** — biggest savings but experimental models
4. **Use Tab to cycle agents:** Build → Plan → General → Explore
5. **Use `@explore` or `@general`** as subagents from Build or Plan mode
6. **Set monthly limits** in Zen dashboard to avoid surprises
7. **Switch models on the fly** with `/models` when you need a different model for a specific task

---

## Last Updated

March 19, 2026
