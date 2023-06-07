#!/usr/bin/env bash
if ! hash zoxide 2>&1 | logger -t bashrc -p user.info; then
  return 1
fi

eval "$(zoxide init bash)"
unset zi
zz() {
  __zoxide_zi "$@"
}


cd() {
  if [[ -z $1 ]]; then
    builtin cd || return
  elif [[ $1 == "--" ]] || [[ $1 == "-" ]]; then
    builtin cd "$@" || return
  elif ! [[ -d $1 ]]; then
    echo -n "$1 is not a directory." >&2
    local dir=$(dirname "$1" 2> /dev/null)
    echo "Stripping component - cd to $dir." >&2
    zoxide add "$dir"
    builtin cd "$dir" || return
  else
    zoxide add "$@"
    builtin cd "$@" || return
  fi
}
