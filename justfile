set shell := ["bash", "-uc"]

setup_ini := "./setup.ini"

default:
    @just --list

# nix develop shell with dependencies for dotfiles install
dev:
    nix develop

# link dotfiles
setup *args:
    install.py {{ setup_ini }} {{ args }}

# create directories
prepare:
    ./install.sh

# create directories and link dotfiles into place
install *args: prepare (setup args)
