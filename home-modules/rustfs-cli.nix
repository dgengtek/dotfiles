{ config, ops_vars, options, lib, pkgs, pkgs-unstable, inputs, ... }:
let
  inherit (ops_vars) env;
in
{
  home.packages = [
    pkgs-unstable.rustfs-cli
  ];

  systemd.user.tmpfiles.rules = [
    "L ${config.xdg.configHome}/rc/config.toml - - - - ${config.sops.templates.rustfs_cli.path}"
  ];

  sops.secrets = {
    rustfs_access_key = { };
    rustfs_secret_key = { };
  };

  # xdg.configFile."mc/config.json" = config.sops.templates.mc_config.path;
  sops.templates."rustfs_cli" = {
    content = ''
      schema_version = 1

      [[aliases]]
      name = "builds"
      endpoint = "https://api-builds.p.i.${env.tld}"
      access_key = "${config.sops.placeholder."rustfs_access_key"}"
      secret_key = "${config.sops.placeholder."rustfs_secret_key"}"
      region = "us-east-1"
      [[aliases]]
      name = "bigdata"
      endpoint = "https://api-bigdata.p.i.${env.tld}"
      access_key = "${config.sops.placeholder."rustfs_access_key"}"
      secret_key = "${config.sops.placeholder."rustfs_secret_key"}"
      region = "us-east-1"
      [[aliases]]
      name = "bigtmp"
      endpoint = "https://api-bigtmp.p.i.${env.tld}"
      access_key = "${config.sops.placeholder."rustfs_access_key"}"
      secret_key = "${config.sops.placeholder."rustfs_secret_key"}"
      region = "us-east-1"
    '';
  };
}
