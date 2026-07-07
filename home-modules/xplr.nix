{ config, options, lib, pkgs, ... }:
{
  programs.xplr = {
    enable = true;
    extraConfig = builtins.readFile ../xplr/.config/xplr/init.lua;
  };
}
