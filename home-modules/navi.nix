{ config, options, lib, pkgs, ... }:
let
  mycheats = ../navi/.local/share/navi/cheats/mycheats;
in
{
  programs = {
    navi = {
      enable = true;
      settings = {
        style = {
          tag = {
            color = "dark_yellow";
            width_percentage = 5;
            min_width = 20;
          };
          comment = {
            color = "grey";
            width_percentage = 42;
            min_width = 45;
          };
          snippet = {
            color = "cyan";
          };
        };
        cheats.paths = [
          mycheats
        ];

        finder = {
          command = "fzf";
          overrides = "--with-nth=..";
        };

        shell = {
          command = "bash";
        };
      };
    };
  };
}
