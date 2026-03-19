#!/usr/bin/env bash
set -euo pipefail
AGENTS_SOURCE="$HOME/agency-agents"
AGENTS_TARGET="$HOME/.claude/agents"
PROJECTS_DIR="$HOME/projects"
read -rp "Project name: " PROJECT_NAME
read -rp "Type [dev/research]: " PROJECT_TYPE
PROJECT_DIR="$PROJECTS_DIR/$PROJECT_NAME"
mkdir -p "$PROJECT_DIR"
mkdir -p "$AGENTS_TARGET"
if [ -d "$AGENTS_SOURCE" ]; then
  cp -r "$AGENTS_SOURCE"/. "$AGENTS_TARGET/"
  echo "agents synced"
else
  echo "warn: $AGENTS_SOURCE not found, skipping agent sync"
fi
cat > "$PROJECT_DIR/CLAUDE.md" << CLAUDEEOF
# $PROJECT_NAME
## environment
- host: WSL2 Ubuntu on DTC-5CG4155DQ9
- gpu: NVIDIA RTX 2000 Ada · 8GB VRAM · CUDA 12.9
- node: managed via fnm (v24+)
- shell: zsh
- type: $PROJECT_TYPE
## conventions
- prefer explicit over implicit
- no comments in copy-paste blocks
- scripts under 50 lines, single file, no required arguments
- containers over VMs unless GPU passthrough is needed
## agents
loaded from ~/.claude/agents — activate by name in session
## plugins
- oh-my-claudecode: multi-agent orchestration
- cli-anything: generate CLIs for any codebase
- impeccable: design skills and commands
CLAUDEEOF
if [ "$PROJECT_TYPE" = "research" ]; then
  cat >> "$PROJECT_DIR/CLAUDE.md" << RESEOF
## research
- GPU available locally (RTX 2000 Ada, 8GB VRAM, CUDA 12.9)
- use new-research.sh to scaffold autoresearch experiments
RESEOF
fi
cd "$PROJECT_DIR"
git init -q
echo "node_modules/" > .gitignore
echo ".env" >> .gitignore
echo "*.log" >> .gitignore
echo ""
echo "ready: $PROJECT_DIR"
echo "run:   cd $PROJECT_DIR && claude"
