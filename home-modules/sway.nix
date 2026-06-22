{ config, options, lib, pkgs, ... }:
{
  programs.i3status-rust.enable = true;
  xdg.configFile."i3status-rust/config.toml".source = ../i3status-rust/config.toml;
  xdg.configFile."i3status-rust/configinfo.toml".source = ../i3status-rust/configinfo.toml;
}
