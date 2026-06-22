{ config, options, lib, pkgs, ... }:
{
  imports = [
    ./dunst.nix
    ./bash.nix
    ./tmux.nix
    ./git.nix
    ./email.nix
    ./sops.nix
    ./pass.nix
    ./fzf.nix
    ./navi.nix
    ./audio.nix
  ];
}
