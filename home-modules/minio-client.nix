{ config, ops_vars, options, lib, pkgs, inputs, ... }:
let
  inherit (ops_vars) env;
in
{
  home = {
    sessionVariables = {
      MC_CONFIG_DIR = "${config.xdg.configHome}/mc";
    };
  };

  systemd.user.tmpfiles.rules = [
    "L ${config.xdg.configHome}/mc/config.json - - - - ${config.sops.templates.mc_config.path}"
  ];

  sops.secrets = {
    minio_access_key = { };
    minio_secret_key = { };
  };

  # xdg.configFile."mc/config.json" = config.sops.templates.mc_config.path;
  sops.templates."mc_config" = {
    content = ''
      {
        "version": "10",
        "aliases": {
          "bigdata": {
            "url": "https,,/api-bigdata.p.${env.domain}",
            "accessKey": "${config.sops.placeholder."minio_access_key"}",
            "secretKey": "${config.sops.placeholder."minio_secret_key"}",
            "api": "s3v4",
            "path": "auto"
          },
          "bigtmp": {
            "url": "https://api-bigtmp.p.${env.domain}",
            "accessKey": "${config.sops.placeholder."minio_access_key"}",
            "secretKey": "${config.sops.placeholder."minio_secret_key"}",
            "api": "s3v4",
            "path": "auto"
          },
          "builds": {
            "url": "https://api-builds.p.${env.domain}",
            "accessKey": "${config.sops.placeholder."minio_access_key"}",
            "secretKey": "${config.sops.placeholder."minio_secret_key"}",
            "api": "s3v4",
            "path": "auto"
          }
        }
      }
    '';
  };
}
