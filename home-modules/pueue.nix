{ config, options, lib, inputs, pkgs, ... }:
{
  programs.pueue.enable = true;
  xdg.configFile."pueue/pueue.yml".source = ../pueue/.config/pueue/pueue.yml;
}
