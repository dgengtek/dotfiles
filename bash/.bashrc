# See bash(1) for more options
set -o pipefail
# If not running interactively, don't do anything
[[ $- != *i* ]] && exit 3

# Time out for root user
if (($UID == 0 )); then
  TMOUT=900
fi

source_file() {
  if [[ -f $1 ]]; then
    source "$1"
  fi
}
source_dir() {
  while IFS= read -r -d $'\0' file; do
    source_file "$file"
  done < <(find -L "$1" -type f -not -name *.swp -print0 | LC_COLLATE=C sort -dz)
}

export PATH_BASH_CONFIG="$HOME/.config/bash.d/"

# using starship prompt instead
# source_file "$PATH_BASH_CONFIG/prompt"
source_file "$PATH_BASH_CONFIG/options"

source_dir "$PATH_BASH_CONFIG/exports"
source_dir "$PATH_BASH_CONFIG/utils"
source_dir "$PATH_BASH_CONFIG/aliases"

# source third party completions
source_file /usr/share/bash-completion/completions/git
source_file "$HOME/.local/share/bash-completion/completions/fzf"
source_file "$HOME/.local/share/bash-completion/completions/fzf-key-bindings.bash"

# override with custom completions
source_dir "$PATH_BASH_CONFIG/completion"

source_file "$HOME/.LESS_TERMCAP"

unset source_file
unset source_dir

if [[ -d "$HOME/.anacron" ]]; then
  /usr/sbin/anacron -s \
    -t ${HOME}/.anacron/etc/anacrontab \
    -S ${HOME}/.anacron/spool
fi

# Set GPG TTY
export GPG_TTY=$(tty)

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null

# Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

if hash starship; then
 eval "$(starship init bash)"
else
 echo "Install starship to use custom prompt." >&2
fi
