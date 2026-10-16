#!/usr/bin/env bash
#
# Starts (or attaches to) a tmux session with a plain shell on top and
# lazygit on the bottom, split evenly, in the current directory.

set -euo pipefail

SESSION_NAME="${1:-main}"
DIR="$(pwd)"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  exec tmux attach -t "$SESSION_NAME"
fi

tmux new-session -d -s "$SESSION_NAME" -c "$DIR"
tmux split-window -v -l 50% -t "$SESSION_NAME" -c "$DIR"
tmux send-keys -t "$SESSION_NAME.2" "lazygit" C-m
tmux select-pane -t "$SESSION_NAME.1"

exec tmux attach -t "$SESSION_NAME"
