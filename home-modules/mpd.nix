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
      musicDirectory = "/auto/data/music";
      network = {
        inherit port listenAddress;
      };
    };
  };
  home.packages = [ pkgs.mpc ];
}
