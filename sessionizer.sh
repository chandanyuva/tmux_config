#!/usr/bin/env bash

# List existing tmux sessions
sessions=$(tmux list-sessions -F "#S" 2>/dev/null)

DIRS=(
	"$HOME/"
	"$HOME/.config/"
)

# Add "New Session" option on top
options=$(printf "🆕 New Session\n%s" "$sessions")

selected=$(printf "%s\n" "$options" | fzf \
  --reverse \
  --border=rounded \
  --height=80% \
  --margin=2,4 \
  --info=inline \
  --prompt="Session> ")

if [[ -z "$selected" ]]; then
  exit 0
fi

if [[ "$selected" == "🆕 New Session" ]]; then
  # Run another fzf for picking folder
  folder=$(fd . "${DIRS[@]}" --type d --hidden --exclude ".git" --max-depth 5 \
	| sed "s|^$HOME/||" \
  	| fzf \
    	--reverse \
    	--border=rounded \
    	--height=80% \
    	--margin=2,4 \
    	--info=inline \
    	--prompt="Folder> ")

  [[ -z "$folder" ]] && exit 0

  session_name=$(basename "$folder" | tr . _)

  tmux new-session -d -s "$session_name" -c "$folder"
  tmux switch-client -t "$session_name"
else
  tmux switch-client -t "$selected"
fi

