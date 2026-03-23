#!/usr/bin/env bash
set -euo pipefail
AUTORESEARCH_SOURCE="$HOME/autoresearch"
PROJECTS_DIR="$HOME/projects"
read -rp "Experiment name: " EXP_NAME
EXP_DIR="$PROJECTS_DIR/autoresearch-$EXP_NAME"
if [ ! -d "$AUTORESEARCH_SOURCE" ]; then
  git clone https://github.com/karpathy/autoresearch.git "$AUTORESEARCH_SOURCE"
fi
cp -r "$AUTORESEARCH_SOURCE" "$EXP_DIR"
cd "$EXP_DIR"
python3 -m venv .venv
source .venv/bin/activate
pip install -q -r requirements.txt
echo ""
echo "ready: $EXP_DIR"
echo "run:   cd $EXP_DIR && source .venv/bin/activate && python autoresearch.py"
