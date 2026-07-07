{ config, options, lib, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    theme = "DarkBlue";

    # This section covers the configuration { ... } block
    extraConfig = {
      font = "Terminus 14";
      terminal = "alacritty";
    };
  };
}
