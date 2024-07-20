#!/usr/bin/env bash
if ! command -v vipe 2>&1 | logger -t bashrc -p user.info; then
	return 1
fi

__edit_readline_in_editor() {
	new_line=$(echo "$READLINE_LINE" | vipe)
	if [[ -n "$new_line" ]]; then
		READLINE_LINE="$new_line"
	fi
}
# alt+e
bind -x '"\ee": __edit_readline_in_editor'
