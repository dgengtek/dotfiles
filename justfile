set shell := ["bash", "-uc"]
alias d := dev

setup_ini := "./setup.ini"

default:
    @just --list

# nix develop shell with dependencies for dotfiles install
[group("dev")]
dev:
    nix develop

# link dotfiles
[group("apply")]
setup *args:
    install.py {{ setup_ini }} {{ args }}

# create directories
[group("apply")]
prepare:
    ./install.sh

# create directories and link dotfiles into place
[group("apply")]
install *args: prepare (setup args)

[group("apply")]
home:
    nix run home-manager -- switch --flake ".#dgeng@wsdg"

[group("build")]
home-manager-build: flake-custom-update
    NIXPKGS_ALLOW_UNFREE=1 home-manager build --impure --flake .

[group("update")]
flake-custom-update:
    nix flake update scripts nixutils ops-vars

[group("test")]
nu: home-manager-build
    ./result/home-path/bin/nu --config ./result/home-files/.config/nushell/config.nu --env-config ./result/home-files/.config/nushell/env.nu

[group("test")]
bash: home-manager-build
    ./result/home-path/bin/bash --rcfile ./result/home-files/.bashrc
