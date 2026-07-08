{ config, options, lib, ops_vars, pkgs, ... }:
let
  inherit (ops_vars) env;
in
{
  home.file = {
    ".pulumi/credentials.json".text = builtins.toJSON {
      current = "postgres://user_pulumi@postgres.p.${env.domain}:5432?sslmode=require&connect_timeout=30";
      accessTokens = {
        "postgres://user_pulumi@postgres.p.${env.domain}:5432?sslmode=require&connect_timeout=30" = "";
      };
      accounts = {
        "postgres://user_pulumi@postgres.p.${env.domain}:5432?sslmode=require&connect_timeout=30" = {
          "lastValidatedAt" = "0001-01-01T00:00:00Z";
        };
      };
    };
  };
}
