#!/usr/bin/env bash
if ! command -v broot 2>&1 | logger -t bashrc -p user.info; then
	return 1
fi

function br {
	local cmd cmd_file code
	cmd_file=$(mktemp)
	if broot --outcmd "$cmd_file" "$@"; then
		cmd=$(<"$cmd_file")
		command rm -f "$cmd_file"
		eval "$cmd"
	else
		code=$?
		command rm -f "$cmd_file"
		return "$code"
	fi
}

alias bo="broot --conf '$HOME/.config/broot/conf.hjson;$HOME/.config/broot/select.toml'"

unalias z 2>/dev/null
z() {
	local dir=$(broot --conf "$HOME/.config/broot/conf.hjson;$HOME/.config/broot/selectd.toml")
	if [[ -z "$dir" ]]; then
		builtin cd || return
	fi
	if [[ -f "$dir" ]]; then
		dir=$(dirname "$dir")
	fi
	cd "$dir"
}
