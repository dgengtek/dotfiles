#!/usr/bin/env bash


cd() {
  if [[ -z $1 ]]; then
    builtin cd
  elif [[ $1 == "--" ]] || [[ $1 == "-" ]]; then
    fsbookmark.sh -q add "$@"
    builtin cd "$@"
  elif ! [[ -d $1 ]]; then
    echo -n "$1 is not a directory." >&2
    local dir=$(dirname "$1" 2> /dev/null)
    echo "Stripping component - cd to $dir." >&2
    fsbookmark.sh -q add "$dir"
    builtin cd "$dir"
  else
    fsbookmark.sh -q add "$@"
    builtin cd "$@"
  fi
}


awksleep() {
  # slow down command output
  local -r sleep_time=${1:-'0.5'}
  awk "{if (system(\"sleep $sleep_time && exit 2\") != 2) exit; print}"
}


cdl() { cd "$@"; ls; }


ping_host() {
  local -r host=$1
  if [[ -z $host ]]; then
    echo "No host has been supplied." >&2
    return 1
  fi 
  trap "trap - SIGINT;echo -e '\nInterrupted ping.';return 1" SIGINT
  echo "PING ==> ${host}..."
  until ping -W 3 -c 1 "$host" >& /dev/null; do echo -n "." >&2;(sleep 1 & wait); done
  echo
  if ping -c 1 "$host" >& /dev/null; then
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
  shift 2
  if ! hash nc; then
    echo "nc not found in path." >&2
    return 1
  fi 
  if [[ -z $host ]]; then
    echo "No host has been supplied." >&2
    return 1
  fi 
  trap "trap - SIGINT;echo -e '\nInterrupted nc.';return 1" SIGINT
  echo "PING ==> ${host}:${port}..."
  until nc -w 3 -vz "$host" "$port" >& /dev/null; do echo -n "." >&2;(sleep 1 & wait); done
  echo
  if nc -w 3 -vz "$host" "$port" >& /dev/null; then
    echo "+ ${host}:${port}" >&2
    return 0
  else
    echo "- ${host}:${port}" >&2
    return 1
  fi
}


pushd() {
  if (($# > 1)); then
    # force error by pushd
    builtin pushd too many arguments
    return $?
  fi

  local dir="$@"
  if ! [[ -d $dir ]]; then
    dir=$(dirname "$dir" 2> /dev/null)
    builtin pushd "$dir"
  else
    builtin pushd "$@"
  fi
}


list_colors() {
  local -r color='\x1b[38;5;'
  printf %s "Displayed colors N: ${color}Nm"
  echo
  for i in {1..255} ; do
    printf "\x1b[38;5;${i}mcolour${i},"
    if ((i%8 == 0)); then
      echo
    fi
  done
  echo
}


watch_until() {
  local -r interval=1
  # run until command succeeds
  trap "trap - SIGINT;return;" SIGINT
  while ! $@; do
    sleep $interval
  done
}
alias watchu=watch_until
alias loopu=watch_until


watch_time() {
  local -r interval=1
  # run until command succeeds
  trap "trap - SIGINT;return;" SIGINT
  while /usr/bin/time -f 'real %e, user %U, sys %S' $@; do
    sleep $interval
  done
}
alias repeat_time=watch_time


retry() {
  local -r n_times=${1:?arg1 for n times missing to retry a failing command}
  local -r interval=${2:?arg2 sleep seconds between failing command missing}
  shift 2
  # run until command succeeds
  trap "trap - SIGINT;return;" SIGINT
  while ! $@; do
    sleep $interval
  done
}


watch_while() {
  local -r interval=1
  # run while command succeeds
  trap "trap - SIGINT;return;" SIGINT
  while $@; do
    sleep $interval
  done
}
alias watchw=watch_while
alias loop=watch_while


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
  # push all directories to stack for navigation
  local -r cwd=$PWD
  local tmpcwd=
  local failed=0
  for i in "$@"; do
    tmpcwd=$(realpath "$cwd/$i")
    if [[ -d "$i" ]]; then
      pushd "$i" || failed=1
    elif [[ -d "$tmpcwd" ]]; then
      pushd "$(realpath $tmpcwd)" || failed=1
    else
      pushd "$(realpath $i)" || failed=1
    fi
    if (($failed)); then
      builtin cd $cwd 
      dirs -c 
      return 1
    fi
  done
  pushd "${@: -1}"
}


paste() {
  local file=${1:-/dev/stdin}
  curl --data-binary @${file} https://paste.rs
}


xargs_vim() {
  xargs bash -c '</dev/tty vim "$@"' ignoreme
}


open() {
  xdg-open "${@:-}" </dev/null >/dev/null 2>&1 \
    & disown
}
