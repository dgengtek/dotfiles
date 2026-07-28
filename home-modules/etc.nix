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
  home.packages = [
    pkgs.zathura
    pkgs.foliate
    pkgs.swayimg
  ];
  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "zathura.desktop" ];

        "application/epub+zip" = [ "com.github.johnfactotum.Foliate.desktop" ];
        "application/x-mobipocket-ebook" = [ "com.github.johnfactotum.Foliate.desktop" ];

        "application/x-extension-htm" = [ "firefox.desktop" ];
        "application/x-extension-html" = [ "firefox.desktop" ];
        "application/x-extension-shtml" = [ "firefox.desktop" ];
        "application/x-extension-xht" = [ "firefox.desktop" ];
        "application/x-extension-xhtml" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/chrome" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];

        "images/png" = [ "swayimg.desktop" ];
        "images/jpg" = [ "swayimg.desktop" ];
        "images/webp" = [ "swayimg.desktop" ];
        "images/svg+xml" = [ "swayimg.desktop" ];
        "images/jpeg" = [ "swayimg.desktop" ];
      };
    };
  };
}
