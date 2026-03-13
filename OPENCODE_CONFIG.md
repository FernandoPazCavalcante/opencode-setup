# OpenCode Configuration - Cost Optimization Strategy

## Config Location

Global config: `~/.config/opencode/opencode.json`

## Agent Model Assignments

| Agent | Model | Role | Cost (per 1M tokens) |
|-------|-------|------|---------------------|
| **build** | Claude Opus 4.6 | Primary - code generation & edits | $5 in / $25 out |
| **plan** | Claude Sonnet 4.6 | Primary - analysis without edits | $3 in / $15 out |
| **general** | Claude Sonnet 4.6 | Subagent - research & multi-step tasks | $3 in / $15 out |
| **explore** | Claude Haiku 4.5 | Subagent - read-only codebase search | $1 in / $5 out |
| **title** | Claude Haiku 4.5 | System - session title generation | $1 in / $5 out |
| **summary** | Claude Haiku 4.5 | System - session summary | $1 in / $5 out |
| **compaction** | Claude Sonnet 4.6 | System - context compaction | $3 in / $15 out |

## Step Limits

| Agent | Max Steps | Reason |
|-------|-----------|--------|
| **explore** | 10 | Read-only searches should be fast |
| **general** | 15 | Research tasks capped to avoid runaway costs |

## Rationale

- **Build (Opus 4.6):** Highest quality model for the primary task — writing and editing code. This is where quality matters most.
- **Plan (Sonnet 4.6):** Analysis and code review don't need Opus-level intelligence. Sonnet is 40% cheaper and excellent for planning.
- **General (Sonnet 4.6):** Multi-step research tasks. Sonnet handles these well at 40% less cost.
- **Explore (Haiku 4.5):** Read-only file search, grep, glob. Haiku is more than capable at 80% cheaper.
- **Title/Summary (Haiku 4.5):** Trivial tasks (5-word titles, short summaries). 80% cheaper.
- **Compaction (Sonnet 4.6):** Context summarization. Sonnet handles this well.

## Estimated Savings

Assuming subagents and system agents consume ~40% of total tokens:
- Before: 100% at Opus pricing
- After: ~60% Opus + ~25% Sonnet + ~15% Haiku
- **Estimated savings: 30-50% on total bill**

## Usage Tips

1. **Use Plan mode first** (Tab key) to analyze before building — runs on cheaper Sonnet
2. **Use `@explore`** for codebase questions instead of letting Build search with Opus
3. **Set monthly limits** in Zen dashboard to avoid surprises
4. **Switch models on the fly** with `/models` when you need Opus for a complex task

## Config Snapshot

```json
{
  "$schema": "https://opencode.ai/config.json",
  "autoupdate": false,
  "model": "opencode/claude-opus-4-6",
  "agent": {
    "build": {
      "model": "opencode/claude-opus-4-6"
    },
    "plan": {
      "model": "opencode/claude-sonnet-4-6"
    },
    "general": {
      "model": "opencode/claude-sonnet-4-6",
      "steps": 15
    },
    "explore": {
      "model": "opencode/claude-haiku-4-5",
      "steps": 10
    },
    "title": {
      "model": "opencode/claude-haiku-4-5"
    },
    "summary": {
      "model": "opencode/claude-haiku-4-5"
    },
    "compaction": {
      "model": "opencode/claude-sonnet-4-6"
    }
  }
}
```

## Last Updated

March 12, 2026
