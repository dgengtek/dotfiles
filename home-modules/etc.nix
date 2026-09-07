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
  home = {
    packages = with pkgs; [
      zathura
      swayimg
      mplayer
      mpv
      smplayer
    ];
    sessionVariables = {
      QT_QPA_PLATFORM = "wayland-egl";
    };
  };

  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];

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

        "video/avi" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/mp4" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/flv" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/mpeg" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/quicktime" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/vnd.rn-realvideo" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/x-matroska" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/x-ms-asf" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/x-msvideo" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/x-ms-wmv" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/x-ogm+ogg" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/x-theora" = [ "vlc.desktop" "mplayer.desktop" ];
        "video/webm" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/ac3" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/mp4" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/mpeg" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/vnd.rn-realaudio" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/vorbis" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/x-adpcm" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/x-matroska" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/x-mp2" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/x-mp3" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/x-ms-wma" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/x-vorbis" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/x-wav" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/mpegurl" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/x-mpegurl" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/x-scpls" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/x-pn-realaudio" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/flac" = [ "vlc.desktop" "mplayer.desktop" ];
        "audio/ogg" = [ "vlc.desktop" "mplayer.desktop" ];
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
