#!/usr/bin/env bash
__find_pattern() {
  if [[ -z $1 ]]; then
    echo "Specify a pattern to search for." >&2
    return 1
  fi
  local -r pattern=$1
  local -a tools=(
  "rg"
  "ag"
  "find"
  )
  local search=
  local -a options=()
  local tool=$(__find_get_tool "${tools[@]}")
  options=($(__find_build_tool_options $tool $pattern))
  $tool "${options[@]}" 2>/dev/null
}
alias f_s=__find_pattern

__find_get_tool() {
  for tool in "$@"; do
    if ! hash "$tool" 2>&1 | logger -t bashrc -p user.info; then
      continue
    fi
    echo "$tool"
    break
  done
}

__find_build_tool_options() {
  local tool=$1
  local pattern=$2
  shift 2
  local options_default=$(__find_get_tool_options_defaults $tool)
  local options_hidden=$(__find_get_tool_options_hidden $tool)
  local options_pattern=$(__find_get_tool_options_pattern $tool $pattern)
  echo "$options_default $options_hidden $options_pattern"
}

__find_get_tool_options_defaults() {
  local -a options
  local tool=$1
  case $tool in
    rg)
      options+=(-i -l -L)
      ;;
    ag)
      options+=(-i -l -f)
      ;;
    find)
      options+=(. -follow -type f)
      ;;
  esac
  echo "${options[@]}"
}

__find_get_tool_options_hidden() {
  local -a options
  local tool=$1
  case $tool in
    rg|ag)
      options+=(--hidden)
      ;;
  esac
  echo "${options[@]}"
}

__find_get_tool_options_pattern() {
  local -a options
  local tool=$1
  local pattern=$2
  case $tool in
    rg|ag)
      options+=("$pattern")
      ;;
    find)
      options+=(-exec grep -i -l "$pattern" {}\;)
      ;;
  esac
  echo "${options[@]}"
}

find_dir() { local path=${1:-.};shift;find "${path}" -type d "$@"; }
find_dir_prune_hidden() { local path=${1:-.};shift;find "${path}" -not -path '*/\.*' -type d "$@"; }
find_dir_depth() { local path=${1:-.};local mindepth=${2:-1};local maxdepth=${3:-1};shift 3;find "${path}" -mindepth "$mindepth" -maxdepth "${maxdepth}" -type d "$@"; }
find_dir_depth_prune_hidden() { local path=${1:-.};local mindepth=${2:-1};local maxdepth=${3:-1};shift 3;find "${path}" -mindepth "$mindepth" -maxdepth "${maxdepth}" -not -path '*/\.*' -type d "$@"; }

find_file() { local path=${1:-.};shift;find "${path}" -type f "$@"; }
find_file_prune_hidden() { local path=${1:-.};shift;find "${path}" -not -path '*/\.*' -type f "$@"; }
find_file_depth() { local path=${1:-.};local mindepth=${2:-1};local maxdepth=${3:-1};shift 3;find "${path}" -mindepth "$mindepth" -maxdepth "${maxdepth}" -type f "$@"; }
find_file_depth_prune_hidden() { local path=${1:-.};local mindepth=${2:-1};local maxdepth=${3:-1};shift 3;find "${path}" -mindepth "$mindepth" -maxdepth "${maxdepth}" -not -path '*/\.*' -type f "$@"; }

finddexec() {
  local -r cwd=$PWD
  local -i i=0

  exec 3<&0
  trap "builtin cd $cwd;exec 3<&-;return" SIGTERM SIGQUIT SIGINT EXIT
  local output=
  local rc=
  cat >&2 << EOF
Capture output to receive a list of directories 
which succeeded at running the supplied command. -- '$@'

EOF

  while IFS= read -r -u 3 -d $'\0' directory; do
    if ! [[ -d "$directory" ]]; then
      echo "{{${directory}}} is not a directory" >&2
      continue
    fi
    let i+=1
    pushd "$directory" >& /dev/null || continue
    output=$(bash -c "$*" 2>&1)
    rc=$?
    if (($rc == 0)); then
      echo "# $i - $directory" >&2
      echo "$directory"
      [[ -n "$output" ]] && echo "$output" >&2
      echo >&2
    fi
    popd >& /dev/null
  done 
  trap - SIGTERM SIGQUIT SIGINT EXIT
  exec 3<&-
}


finddshell() {
  # input lines must be terminated with newlines
  # supply file with directories and enter into an interactive shell if
  #   the command after the first argument succeeds in that directory
  local file_input=${1:?Must supply a file with directories}
  shift

  local cwd=$PWD
  local -r CPID=$$
  local -a directories=()

  while IFS= read -r -d $'\n' directory; do
    if ! [[ -d "$directory" ]]; then
      echo "{{$directory}} is not a directory" >&2
      continue
    fi
    directories+=("$directory")
  done < "$file_input"

  local -r count=${#directories[@]}
  trap "trap - SIGTERM SIGQUIT; builtin cd $cwd; echo 'we are done with interactivity'>&2; return" SIGTERM SIGQUIT SIGINT EXIT
  cat << EOF
running interactive subshells for $count directories.
$ byebye # to stop function
EOF

  for i in $(seq "$count"); do
    pushd "${directories[$i-1]}" >& /dev/null || continue
    if ! bash -c "$*"; then
      echo "==> Condition failed: skipping subshell $i of $count - $PWD" >&2
      popd >& /dev/null
      continue
    fi

  bash --init-file <(cat << EOF
source ~/.bashrc
byebye() { kill -SIGTERM \$\$; }
trap "trap - SIGTERM SIGQUIT; kill -SIGTERM $CPID; exit" SIGTERM SIGQUIT
echo -n "Enter subshell $i of $count - ">&2;pwd
EOF
)
    popd >& /dev/null
  done
  trap - SIGTERM SIGQUIT SIGINT EXIT
  echo "Done." >&2
}
