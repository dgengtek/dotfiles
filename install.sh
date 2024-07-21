#!/usr/bin/env bash
# Install dotfiles
declare -ir ENABLE_COMPLETION_GO=1
declare -ir ENABLE_COMPLETION_RUST=1
declare -ir INSTALL_PYTHON_PACKAGES=1

export PATH="$PATH:$HOME/.local/bin/:$HOME/.bin/"
export PATH_USER_LIB="$HOME/.local/lib/"
readonly path_script="$(dirname "${BASH_SOURCE[0]}")"

# TODO: install external tools I depend on via ansible or in this script

usage() {
	cat >&2 <<EOF
Usage:	${0##*/} [OPTIONS] [<configuration file>]]

OPTIONS:
  -h			  help
  --install-vim
EOF
}

main() {
	# flags
	local -i enable_verbose=0
	local -i enable_quiet=0
	local -i enable_debug=0

	local -a options
	local -a args
	local -i flag_install_vim_plugins=0

	check_dependencies
	# parse input args
	parse_options "$@"
	# set leftover options parsed local input args
	set -- ${args[@]}
	# remove args array
	unset -v args
	check_input_args "$@"

	set_signal_handlers
	prepare_env
	pre_run
	run "$@"
	post_run
	unset_signal_handlers
}

################################################################################
# script internal execution functions
################################################################################

run() {
	local command=$1
	if [[ $(type -t _${command}) == "function" ]]; then
		echo "ran $command"
		_${command}
	else
		install_plugins
		if command -v fzf 2>&1 | logger -t bashrc -p user.info; then
			local fzf_version=$(fzf --version | cut -d ' ' -f 1)
			local fzf_url="https://raw.githubusercontent.com/junegunn/fzf/${fzf_version}/shell"
			curl -o "$HOME/.local/share/bash-completion/completions/fzf" "${fzf_url}/completion.bash"
			curl -o "$HOME/.local/share/bash-completion/completions/fzf-key-bindings.bash" "${fzf_url}/key-bindings.bash"
		fi

		print_dependencies
	fi
}

check_input_args() {
	:
}

prepare_env() {
	set_descriptors
}

set_descriptors() {
	if (($enable_verbose)); then
		exec {fdverbose}>&2
	else
		exec {fdverbose}>/dev/null
	fi
	if (($enable_debug)); then
		set -xv
		exec {fddebug}>&2
	else
		exec {fddebug}>/dev/null
	fi
}

set_signal_handlers() {
	trap sigh_abort SIGABRT
	trap sigh_alarm SIGALRM
	trap sigh_hup SIGHUP
	trap sigh_cont SIGCONT
	trap sigh_usr1 SIGUSR1
	trap sigh_usr2 SIGUSR2
	trap sigh_cleanup SIGINT SIGQUIT SIGTERM EXIT
}

unset_signal_handlers() {
	trap - SIGABRT
	trap - SIGALRM
	trap - SIGHUP
	trap - SIGCONT
	trap - SIGUSR1
	trap - SIGUSR2
	trap - SIGINT SIGQUIT SIGTERM EXIT
}

pre_run() {
	:
}
post_run() {
	:
}

parse_options() {
	# exit if no options left
	[[ -z $1 ]] && return 0
	log "parse \$1: $1" 2>&$fddebug

	local do_shift=0
	case $1 in
	-d | --debug)
		enable_debug=1
		;;
	-v | --verbose)
		enable_verbose=1
		;;
	-q | --quiet)
		enable_quiet=1
		;;
	-h | --help)
		usage
		exit 0
		;;
	-p | --path)
		path=$2
		do_shift=2
		;;
	--)
		do_shift=3
		;;
	--install-vim)
		let flag_install_vim_plugins=1
		;;
	*)
		do_shift=1
		;;
	esac
	if (($do_shift == 1)); then
		args+=("$1")
	elif (($do_shift == 2)); then
		# got option with argument
		shift
	elif (($do_shift == 3)); then
		# got --, use all arguments left as options for other commands
		shift
		options+=("$@")
		return
	fi
	shift
	parse_options "$@"
}

sigh_abort() {
	trap - SIGABRT
}

sigh_alarm() {
	trap - SIGALRM
}

sigh_hup() {
	trap - SIGHUP
}

sigh_cont() {
	trap - SIGCONT
}

sigh_usr1() {
	trap - SIGUSR1
}

sigh_usr2() {
	trap - SIGUSR2
}

sigh_cleanup() {
	trap - SIGINT SIGQUIT SIGTERM EXIT
	local active_jobs
	active_jobs=$(jobs -p)
	for p in $active_jobs; do
		if [[ -e "/proc/$p" ]]; then
			kill "$p" >/dev/null 2>&1
			wait "$p"
		fi
	done
}

print_dependencies() {
	if ! (command -v fzf && command -v rg); then
		echo "Remember to install fzf and ripgrep(rg) manully for utilities." >&2
	fi
}

check_dependencies() {
	command -v python3 || error_exit 1 "Python 3 is missing."
	if ! command -v stow 2>&1 | logger -t install -p user.info; then
		error "'stow' is required for installation."
	fi
}

install_plugins() {
	(($flag_install_vim_plugins)) && install_vim_plugins
	# install_python_packages
	install_tmux_plugins
}

prepare() {
	export PATH_USER_LIB=${PATH_USER_LIB:-"$HOME/.local/lib/"}
	set_descriptors

	# TODO: move directory setup to configuration file(install.py)
	local parent_path
	parent_path=$(
		cd "$path_script" || exit
		pwd -P
	)
	cd "$parent_path" || exit
	pwd
	curl -o "$path_script/vale/.local/share/vale/styles/deutsch/index.dic" 'https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/de/index.dic'
	curl -o "$path_script/vale/.local/share/vale/styles/deutsch/index.aff" 'https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/de/index.aff'
	pushd "$HOME" || exit
	mkdir -p .local/share/bash-completion/completions
	mkdir -p .local/share/navi/cheats
	mkdir -p .config/bash.d/{utils,aliases,exports}
	mkdir -p .config/{ranger,awesome,git,i3,i3status,pueue,navi}
	mkdir -p .config/systemd/user
	mkdir .tmuxp
	mkdir .mpd
	mkdir .vim
	(
		umask 077
		mkdir -p .gnupg
		mkdir -p .ssh/sockets
	)
	popd || exit
}

install_vim_plugins() {
	command -v curl git || exit 2
	if command -v nvim; then
		git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
		nvim -c "PackerSync" -c "qa"
	elif command -v vim; then
		curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		vim -c "PluginInstall" -c "qa"
	else
		exit 2
	fi
}

install_tmux_plugins() {
	# prefix + I
	#   Installs new plugins from GitHub or any other git repository
	#   Refreshes TMUX environment
	# prefix + U
	#   updates plugin(s)
	# prefix + alt + u
	#   remove/uninstall plugins not on the plugin list
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true
}

install_python_packages() {
	(($INSTALL_PYTHON_PACKAGES)) || return 1
	local -r packages=(
		"tmuxp"
		"with"
	)
	pip install --user "${packages[@]}"
}

if [[ $(type -t error) != "function" ]]; then
	echo() (
		IFS=" "
		printf '%s\n' "$*"
	)
	out() { echo "$1 $2" "${@:3}"; }
	error() { out "==> ERROR:" "$@"; } >&2
	error_exit() {
		local rc=$1
		shift
		error "$@"
		exit $rc
	}
	hashq() { command -v "$@" >/dev/null 2>&1; }
fi

prepare
main "$@"
