{ config, options, lib, pkgs, ... }:
{
  sops.secrets = {
    github_access_token = { };
  };

  nix.extraOptions = ''
    include ${config.sops.templates.nix-access-tokens.path}
  '';

  sops.templates."nix-access-tokens" = {
    content = ''
      access-tokens = github.com=${config.sops.placeholder."github_access_token"}
    '';
  };
}
