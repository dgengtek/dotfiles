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
