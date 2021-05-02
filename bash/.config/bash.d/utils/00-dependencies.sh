#!/usr/bin/env bash

make-completion-wrapper() {
  local function_name="$2"
  local arg_count=$(( $#-3 ))
  local comp_function_name="$1"
  shift 2
  local function="function $function_name {
      (( COMP_CWORD += $arg_count ))
      COMP_WORDS=( \"\$@\" \${COMP_WORDS[@]:1} )
      \"$comp_function_name\"
      return 0
    }"
  eval "$function"
}

# use to define aliases
navialias() {
    navi --query ":: $*" --best-match
}
# alias el="navialias el"
# alias ef="navialias ef"

declarealias() {
  alias $1="navialias '$1'"
}

# use to match directly to strings
navibestmatch() {
    navi --query "$1" --best-match
}
# alias el="navibestmatch 'This is one command'"
# alias ef="navibestmatch 'This is another command'"

declarealiasf() {
  alias $1="navibestmatch '$1'"
}
