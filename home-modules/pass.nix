{ config, options, lib, pkgs, ... }:
{
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/repos/password-store";
      PASSWORD_STORE_CHARACTER_SET = "[:graph:]";
      PASSWORD_STORE_GENERATED_LENGTH = "16";
      PASSWORD_STORE_CLIP_TIME = "15";
      PASSWORD_STORE_UMASK = "077";
    };
  };
}
