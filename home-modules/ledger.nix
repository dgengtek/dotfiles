{ config, options, lib, pkgs, ... }:
{
  programs.ledger = {
    enable = true;
    settings = {
      file = [
        "${config.xdg.dataHome}/repos/accounting/journal/index"
      ];
      strict = true;
      sort = "date";
      exchange = "EUR";
    };
  };
}
