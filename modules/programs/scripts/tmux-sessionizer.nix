{pkgs}:

pkgs.writeShellScriptBin "tmux-sessionizer" ''
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/Drive/Drive1/Obsidian ~/Repos ~/Gitlab ~/Github ~/.config -mindepth 1 -maxdepth 1 -type d | fzf)
fi

[[ -z "$selected" ]] && exit 0

selected_name=$(basename "$selected" | tr . _)
init_file="/tmp/.tmux_project_init_$(echo "$selected" | md5sum | cut -d' ' -f1)"

# Write project-specific init script in /tmp
cat > "$init_file" <<'EOF'
export PROJECT_ROOT="$selected"
cd() {
  local input="''${1:-}"
  if [[ -z "$input" || "$input" == "~" || "$input" == "$HOME" ]]; then
    builtin cd "$PROJECT_ROOT"
  else
    builtin cd "$input"
  fi
}
EOF

# Only create session if it doesn't exist
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected" \
      "zsh --rcs -c 'source \"$init_file\"; cd \$PROJECT_ROOT; exec zsh'"
    tmux set-option -t "$selected_name" default-path "$selected"
    tmux set-environment -t "$selected_name" PROJECT_ROOT "$selected"
fi

# Attach or switch to session
if [[ -z "$TMUX" ]]; then
    tmux attach -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi
''
