#!/usr/bin/env bash

pyvenv() {
  local venv=venv
  if [[ -d venv ]]; then
    venv=venv
  elif [[ -d .venv ]]; then
    venv=.venv
  else
    echo "'venv' or '.venv' does not exist. Creating now 'venv'." >& 2
    python3 -m venv "$venv"
  fi

  source "$venv/bin/activate"
}
