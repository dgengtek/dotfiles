{ config, options, lib, pkgs, ... }:
{
  services.dunst = {
    enable = true;
    configFile = ../dunst/.config/dunst/dunstrc;
  };
}
