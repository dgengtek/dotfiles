#!/usr/bin/env bash
if ! hash vipe 2>&1 | logger -t bashrc -p user.info; then
  return 1
fi


__edit_readline_in_editor() {
  new_line=$(echo "$READLINE_LINE" | vipe)
  if [[ -z "$new_line" ]]; then
    READLINE_LINE="${READLINE_LINE}"
  else
    READLINE_LINE="$new_line"
  fi
}
# alt+s
bind -x '"\ee": __edit_readline_in_editor'
