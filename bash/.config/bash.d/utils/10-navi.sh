#!/usr/bin/env bash
if ! command -v navi 2>&1 | logger -t bashrc -p user.info; then
	return 1
fi

# ctrl+g
eval "$(navi widget bash)"
_navi_widget_append() {
	READLINE_LINE="${READLINE_LINE}$(navi --print)"
}
_navi_call_custom() {
	_navi_call --fzf-overrides '--no-select-1' "$@"
}
_navi_widget_loop() {
	output=()
	while :; do
		selection=$(_navi_call_custom --print)
		if [[ -z "$selection" ]]; then
			break
		fi
		output+=("$selection")
	done
	result=$(printf '%s\n' "${output[@]}" | vipe)

	READLINE_LINE="${READLINE_LINE}$result"
	READLINE_POINT=${#READLINE_LINE}
}
_navi_widget() {
	local -r input="${READLINE_LINE}"
	local -r last_command="$(echo "${input}" | navi fn widget::last_command)"

	if [[ -z "${last_command}" ]]; then
		local -r append="$(_navi_call_custom --print)"
		local -r output="${input}${append}"
	else
		local -r find="${last_command}_NAVIEND"
		local -r replacement="$(_navi_call_custom --print --query "${last_command}")"
		local output="$input"
		if [[ -n "$replacement" ]]; then
			output="${input}_NAVIEND"
			output="${input//$find/$replacement}"
		fi
	fi

	READLINE_LINE="$output"
	READLINE_POINT=${#READLINE_LINE}
}
# alt+s
bind -x '"\es": _navi_widget_append'
