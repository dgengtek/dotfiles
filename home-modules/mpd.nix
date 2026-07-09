{ config, options, lib, pkgs, ... }:
let
  port = 6600;
  listenAddress = "127.0.0.1";
in
{
  services = {
    mpd-mpris = {
      enable = true;
      mpd.useLocal = true;
    };
    mpd = {
      enable = true;
      musicDirectory = "/auto/data/${config.home.username}/music";
      network = {
        inherit port listenAddress;
      };
    };
  };
  home.packages = [ pkgs.mpc ];
}
