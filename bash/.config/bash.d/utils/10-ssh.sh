#!/usr/bin/env bash
if ! command -v fzf 2>&1 | logger -t bashrc -p user.info; then
	echo "fzf missing for ssh utils" >&2
	return 1
fi

__is_ssh_private_key() {
	local -r file=$1
	[[ $(file "$file") =~ "PEM RSA private key" ]]
}

__is_ssh_public_key() {
	local -r file=$1
	[[ $(file "$file") =~ "OpenSSH RSA public key" ]]
}

__get_keys() {
	local -r function=${1:?"Missing function name for key check."}
	while read -d $'\0' file; do
		if "$function" "$file"; then
			echo $(basename "$file")
		fi
	done < <(find $HOME/.ssh -type f -print0)
}
__get_ssh_private_keys() {
	__get_keys __is_ssh_private_key
}
__get_ssh_public_keys() {
	__get_keys __is_ssh_public_key
}
ssh_list_fingerprints() {
	while read -r -d $'\n' key; do
		[[ -z $key ]] && continue
		echo -n "$key "
		ssh-keygen -q -l -f "$HOME/.ssh/$key"
	done < <(__get_ssh_public_keys)
	local key="$HOME/.ssh/authorized_keys"
	! [[ -f $key ]] && return
	echo "$key"
	ssh-keygen -q -l -f "$key"
}

f_ssh_add() {
	while read -r -d $'\0' key; do
		[[ -z $key ]] && continue
		ssh-add "$HOME/.ssh/$key"
	done < <(__get_ssh_private_keys | fzf --select-1 --multi --print0)
	gpg-connect-agent updatestartuptty /bye
}

alias ssha="f_ssh_add"
alias sshls="ssh-add -l"
alias sshlsfp="ssh_list_fingerprints"
