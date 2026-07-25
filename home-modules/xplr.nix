{ config, options, lib, pkgs, ... }:
{
  programs.xplr = {
    enable = true;
    plugins = {
      command-mode = pkgs.fetchFromGitHub {
        owner = "sayanarijit";
        repo = "command-mode.xplr";
      };
      map = pkgs.fetchFromGitHub {
        owner = "sayanarijit";
        repo = "map.xplr";
      };
      context-switch = pkgs.fetchFromGitHub {
        owner = "igorepst";
        repo = "context-switch.xplr";
      };
    };
    extraConfig = builtins.readFile ../xplr/.config/xplr/init.lua;
  };
}
