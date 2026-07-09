{ config, options, lib, pkgs, ... }:
{
  programs.jrnl = {
    enable = true;
    settings = {
      colors = {
        body = null;
        date = null;
        tags = null;
        title = null;
      };
      journals = {
        default = "${config.home.homeDirectory}/mnt/privat/dokumente/logbuch/log.txt";
        tagebuch = "${config.home.homeDirectory}/mnt/privat/dokumente/logbuch/tagebuch.txt";
      };
      default_hour = 9;
      default_minute = 0;
      editor = "nvim";
      encrypt = false;
      highlight = true;
      indent_character = "|";
      linewrap = 79;
      tagsymbols = "@";
      template = false;
      timeformat = "%Y-%m-%d %H:%M";
      version = "v4.2.1";
    };
  };
}
