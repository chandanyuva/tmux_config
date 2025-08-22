#!/bin/bash

DIRS=(
    "$HOME/"
    "$HOME/.config/"
    "$HOME/projects/"
    "$HOME/practice/"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --type d --max-depth=1 --full-path \
        | sed "s|^$HOME/||" \
        | fzf --height=80% --border --reverse --prompt="Select dir > ")
    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)
if ! tmux has-session -t "$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name"

