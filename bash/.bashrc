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

# must be at end
# TODO: does not work with symbolic link for config file
#     https://github.com/starship/starship/issues/1543
#     after fixed remove own prompt and configure starship
if hash starship; then
 eval "$(starship init bash)"
else
 echo "Install starship to use custom prompt." >&2
fi

if hash navi; then
 # ctrl+g
 eval "$(navi widget bash)"
  _navi_widget_append() {
    READLINE_LINE="${READLINE_LINE}$(navi --print)"
  }
  _navi_widget_loop() {
    output=()
    while :; do
      selection=$(navi --print)
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

      if [ -z "${last_command}" ]; then 
          local -r append="$(navi --print --fzf-overrides '--no-select-1')"
          local -r output="${input}${append}"
      else
          local -r find="$last_command"
          local -r replacement="$(navi --print --query "${last_command}")"
          local -r output="${input//$find/$replacement}"
      fi

      READLINE_LINE="$output"
      READLINE_POINT=${#READLINE_LINE}
  }
  # alt+s
  bind -x '"\es": _navi_widget_append'
else
 echo "Install navi to use cheats." >&2
fi

_widget_history_append() {
  # from __fzf_history__
  local output;
  output=$(
  builtin fc -lnr -2147483648 |
    last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e 'BEGIN { getc; $/ = "\n\t"; $HISTCMD = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCMD - $. . "\t$_" if !$seen{$_}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m --read0" $(__fzfcmd) --query "$READLINE_LINE"
  ) || return;
  READLINE_LINE="${READLINE_LINE}${output#*$'\t'}"
}
bind -x '"\eh": _widget_history_append'

if hash mc; then
  complete -C /usr/bin/mc mc
fi
