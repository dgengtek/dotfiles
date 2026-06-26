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
    ".pulumi/workspaces/zerbrechlich-fef603a8ef5c9392e6e1b63b671d903181869709-workspace.json".text = builtins.toJSON {
      "stack" = "organization/zerbrechlich/master";
    };
    ".pulumi/workspaces/einrichtung-a411b54f230b4a38bb673d054286094ccada5c39-workspace.json".text = builtins.toJSON {
      "stack" = "organization/einrichtung/master";
    };
    ".pulumi/workspaces/vault-28ccfd012bb685bded6f62a83354e3386b47fae2-workspace.json".text = builtins.toJSON {
      "stack" = "organization/vault/master";
    };
    ".pulumi/workspaces/infrastruktur-c5e1d2e78a28bec737a1954dbb97c4056d7a7b92-workspace.json".text = builtins.toJSON {
      "stack" = "organization/infrastruktur/master";
    };
  };
}
