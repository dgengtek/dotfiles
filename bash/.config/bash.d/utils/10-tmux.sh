#!/usr/bin/env bash

tmux_pwd() { tmux rename-window "$PWD"; }

tmux_cwd() {
  local -r cwd=$(basename "$PWD")
  tmux rename-window "$cwd"
}

tmux_cwdd() {
  local -r cwdd=$(dirname "$PWD")
  tmux rename-window "$cwdd"
}
