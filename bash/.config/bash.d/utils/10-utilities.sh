#!/usr/bin/env bash

awksleep() {
  # Slow down command output safely
  local -r sleep_time=${1:-0.5}
  awk -v st="$sleep_time" '{if (system("sleep " st " && exit 2") != 2) exit; print}'
}

cdl() {
  cd "$@" && ls
}

ping_host() {
  local -r host=$1
  if [[ -z $host ]]; then
    echo "No host has been supplied." >&2
    return 1
  fi
  trap 'trap - SIGINT; echo -e "\nInterrupted ping."; return 1' SIGINT
  echo "PING ==> ${host}..."
  until ping -W 3 -c 1 "$host" &>/dev/null; do
    echo -n "." >&2
    (
      sleep 1 &
      wait
    )
  done
  echo
  if ping -c 1 "$host" &>/dev/null; then
    echo "+ $host" >&2
    return 0
  else
    echo "- $host" >&2
    return 1
  fi
}

ping_host_port() {
  local -r host=$1
  local -r port=${2:-22}
  if ! command -v nc >/dev/null 2>&1; then
    echo "nc not found in path." >&2
    return 1
  fi
  if [[ -z $host ]]; then
    echo "No host has been supplied." >&2
    return 1
  fi
  trap 'trap - SIGINT; echo -e "\nInterrupted nc."; return 1' SIGINT
  echo "PING ==> ${host}:${port}..."
  until nc -w 3 -vz "$host" "$port" &>/dev/null; do
    echo -n "." >&2
    (
      sleep 1 &
      wait
    )
  done
  echo
  if nc -w 3 -vz "$host" "$port" &>/dev/null; then
    echo "+ ${host}:${port}" >&2
    return 0
  else
    echo "- ${host}:${port}" >&2
    return 1
  fi
}

pushd() {
  if (($# > 1)); then
    echo "pushd: too many arguments" >&2
    return 1
  fi
  local dir="$1"
  if ! [[ -d $dir ]]; then
    dir=$(dirname "$dir" 2>/dev/null)
    builtin pushd "$dir" >/dev/null
  else
    builtin pushd "$1" >/dev/null
  fi
}

list_colors() {
  local -r color='\x1b[38;5;'
  printf '%s\n' "Displayed colors N: ${color}Nm"
  for i in {1..255}; do
    printf '\x1b[38;5;%dmcolour%d,\n' "$i" "$i"
    if ((i % 8 == 0)); then
      echo
    fi
  done
}

watch_until() {
  local -r interval=1
  trap 'trap - SIGINT; return;' SIGINT
  while ! eval "$*"; do
    sleep "$interval"
  done
}
alias watchu=watch_until

watch_time() {
  local -r interval=1
  trap 'trap - SIGINT; return;' SIGINT
  # Wrapping the pipeline in bash -c ensures /usr/bin/time
  # correctly measures the entire pipeline's execution.
  while /usr/bin/time -f 'real %e, user %U, sys %S' bash -c "$*"; do
    sleep "$interval"
  done
}
alias repeat_time=watch_time

watch_while() {
  local -r interval=1
  trap 'trap - SIGINT; return;' SIGINT
  while eval "$*"; do
    sleep "$interval"
  done
}
alias watchw=watch_while

chmod_def() {
  local -r permdir="0755"
  local -r permfile="0644"
  local path=${1:?Supply path to set default permissions.(defaults - file:$permfile,dir:$permdir)}
  find "$path" -type d -exec chmod "$permdir" {} +
  find "$path" -type f -exec chmod "$permfile" {} +
}

chmod_restricted() {
  local -r permdir="0700"
  local -r permfile="0600"
  local path=${1:?Supply path to set default permissions.(defaults - file:$permfile,dir:$permdir)}
  find "$path" -type d -exec chmod "$permdir" {} +
  find "$path" -type f -exec chmod "$permfile" {} +
}

pushd_all() {
  local -r cwd=$PWD
  local tmpcwd=
  local failed=0
  for i in "$@"; do
    tmpcwd=$(realpath "$cwd/$i" 2>/dev/null)
    if [[ -d "$i" ]]; then
      pushd "$i" || failed=1
    elif [[ -d "$tmpcwd" ]]; then
      pushd "$tmpcwd" || failed=1
    else
      pushd "$(realpath "$i" 2>/dev/null)" || failed=1
    fi
    if (($failed)); then
      builtin cd "$cwd"
      dirs -c
      return 1
    fi
  done
  pushd "${@: -1}"
}

paste() {
  local file=${1:-/dev/stdin}
  curl --data-binary "@${file}" https://paste.rs
}

open() {
  xdg-open "${@:-}" </dev/null >/dev/null 2>&1 &
  disown
}
