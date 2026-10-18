{ config, options, lib, pkgs, ... }:
{
  sops.secrets = {
    github_access_token = { };
  };

  systemd.user.tmpfiles.rules = [
    "L ${config.xdg.configHome}/nix/nix-access-tokens.conf - - - - ${config.sops.templates.nix-access-tokens.path}"
  ];

  nix.extraOptions = ''
    !include ${config.xdg.configHome}/nix/nix-access-tokens.conf
  '';

  sops.templates."nix-access-tokens" = {
    content = ''
      access-tokens = github.com=${config.sops.placeholder."github_access_token"}
    '';
  };
}
