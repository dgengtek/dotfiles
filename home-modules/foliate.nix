{ config, options, lib, ops_vars, pkgs, ... }:
let
  inherit (ops_vars) env;
in
{
  programs.foliate = {
    enable = true;
    settings = {
      color-scheme = 1;
      library = {
        view-mode = "single";
      };
      "viewer/view" = {
        animated = false;
      };
      "viewer/font" = {
        monospace = "Iosevka";
        sans-serif = "Inter var";
        serif = "Libertinus Serif";
      };
    };
  };
}
