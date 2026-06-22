{ config, options, lib, pkgs, ... }:
{
  programs.i3status-rust.enable = true;
  xdg.configFile."i3status-rust/config.toml".text = ../i3status-rust/config.toml;
  xdg.configFile."i3status-rust/configinfo.toml".text = ../i3status-rust/configinfo.toml;
}
