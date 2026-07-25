{ config, options, lib, pkgs, ... }:
{
  programs.xplr = {
    enable = true;
    plugins = {
      command-mode = pkgs.fetchFromGitHub {
        owner = "sayanarijit";
        repo = "command-mode.xplr";
        rev = "main";
        sha256 = "sha256-Yt2x2ebSsvFVt05kTD7cWQiRy/ab/O3h+klhCeVXLHQ=";
      };
      map = pkgs.fetchFromGitHub {
        owner = "sayanarijit";
        repo = "map.xplr";
        rev = "main";
        sha256 = "sha256-ryVvZIMBkG7FpJVpEj0SfibWFDEEsvA8089ptErlqwg=";
      };
      context-switch = pkgs.fetchFromGitHub {
        owner = "igorepst";
        repo = "context-switch.xplr";
        rev = "main";
        sha256 = "sha256-ryVvZIMBkG7FpJVpEj0SfibWFDEEsvA8089ptErlqwg=";
      };
    };
    extraConfig = builtins.readFile ../xplr/.config/xplr/init.lua;
  };
}
