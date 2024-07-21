set shell := ["bash", "-uc"]

setup_ini := "./setup.ini"

default:
    @just --list

dev:
    nix develop

setup *args:
    install.py {{ setup_ini }} {{ args }}

prepare:
    ./install.sh
