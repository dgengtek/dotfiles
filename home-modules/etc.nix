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
  home.packages = with pkgs; [
    zathura
    foliate
    swayimg
    mplayer
    smplayer
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

        "image/png" = [ "swayimg.desktop" ];
        "image/jpg" = [ "swayimg.desktop" ];
        "image/webp" = [ "swayimg.desktop" ];
        "image/svg+xml" = [ "swayimg.desktop" ];
        "image/jpeg" = [ "swayimg.desktop" ];

        "video/avi" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/mp4" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/flv" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/mpeg" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/quicktime" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/vnd.rn-realvideo" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/x-matroska" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/x-ms-asf" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/x-msvideo" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/x-ms-wmv" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/x-ogm+ogg" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/x-theora" = [ "mplayer.desktop" "smplayer.desktop" ];
        "video/webm" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/ac3" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/mp4" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/mpeg" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/vnd.rn-realaudio" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/vorbis" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/x-adpcm" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/x-matroska" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/x-mp2" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/x-mp3" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/x-ms-wma" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/x-vorbis" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/x-wav" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/mpegurl" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/x-mpegurl" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/x-scpls" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/x-pn-realaudio" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/flac" = [ "mplayer.desktop" "smplayer.desktop" ];
        "audio/ogg" = [ "mplayer.desktop" "smplayer.desktop" ];
      };
      associations.removed = {
        "image/png" = [ "gimagereader-gtk.desktop" ];
        "image/jpg" = [ "gimagereader-gtk.desktop" ];
        "image/webp" = [ "gimagereader-gtk.desktop" ];
        "image/svg+xml" = [ "gimagereader-gtk.desktop" ];
        "image/jpeg" = [ "gimagereader-gtk.desktop" ];

        "application/pdf" = [ "calibre.desktop" ];
        "application/epub+zip" = [ "calibre.desktop" ];
        "application/x-mobipocket-ebook" = [ "calibre.desktop" ];
      };
    };
  };
}
