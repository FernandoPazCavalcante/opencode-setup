#!/usr/bin/env bash

set -e

PROVIDER="${1}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/opencode"
TARGET="$CONFIG_DIR/opencode.json"

usage() {
  echo "Usage: ./switch.sh [anthropic|zen|zen-codex|zen-ultra]"
  echo ""
  echo "  anthropic   — Anthropic API key, Claude-only, Haiku for all lightweight agents"
  echo "                Build: Sonnet 4.6 | Plan: Opus 4.6 | System: Haiku 4.5"
  echo ""
  echo "  zen         — Zen billing, Sonnet build, free/cheap system agents (recommended)"
  echo "                Build: Sonnet 4.6 | Plan: Opus 4.6 | System: GPT 5 Nano (free) + Gemini Flash"
  echo ""
  echo "  zen-codex   — Zen billing, GPT 5.1 Codex build (~50% cheaper than zen)"
  echo "                Build: GPT 5.1 Codex | Plan: Opus 4.6 | System: GPT 5 Nano (free) + Gemini Flash"
  echo ""
  echo "  zen-ultra   — Zen billing, maximum savings, experimental models"
  echo "                Build: Kimi K2.5 | Plan: Gemini 3.1 Pro | System: GPT 5 Nano (free) + Gemini Flash"
  exit 1
}

if [[ "$PROVIDER" != "anthropic" && "$PROVIDER" != "zen" && "$PROVIDER" != "zen-codex" && "$PROVIDER" != "zen-ultra" ]]; then
  usage
fi

mkdir -p "$CONFIG_DIR"
cp "$SCRIPT_DIR/configs/$PROVIDER.json" "$TARGET"
echo "Switched to provider: $PROVIDER"
echo "Config written to: $TARGET"
