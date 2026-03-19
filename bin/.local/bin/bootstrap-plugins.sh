#!/usr/bin/env bash
set -euo pipefail
MARKETPLACES=(
  "anthropics/claude-plugins-official"
  "obra/superpowers-marketplace"
  "piercelamb/deep-plan"
  "piercelamb/deep-project"
  "piercelamb/deep-implement"
  "thedotmack/claude-mem"
  "https://github.com/Yeachan-Heo/oh-my-claudecode"
  "HKUDS/CLI-Anything"
)
PLUGINS=(
  "code-review@claude-plugins-official"
  "security-guidance@claude-plugins-official"
  "superpowers@superpowers-marketplace"
  "deep-plan"
  "deep-project"
  "deep-implement"
  "claude-mem"
  "oh-my-claudecode"
  "cli-anything"
)
echo "adding marketplaces..."
for m in "${MARKETPLACES[@]}"; do
  echo "/plugin marketplace add $m" | claude --print 2>/dev/null \
    && echo "ok: $m" \
    || echo "warn: $m (may already exist)"
  sleep 1
done
echo ""
echo "installing plugins..."
for p in "${PLUGINS[@]}"; do
  echo "/plugin install $p" | claude --print 2>/dev/null \
    && echo "ok: $p" \
    || echo "warn: $p (may already be installed)"
  sleep 1
done
echo ""
echo "done — restart claude code to activate all plugins"
