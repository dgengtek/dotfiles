{ config, options, lib, pkgs, ... }:
{
  xdg = {
    enable = true;
    configFile."bash.d".source = ../bash/.config/bash.d;
  };
  programs.starship.enable = true;
  programs.bash = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {
      PATH_BASH_CONFIG = config.xdg.configFile."bash.d".source;
    };
    initExtra = ''
      # See bash(1) for more options
      set -o pipefail

      # Time out for root user
      if (($UID == 0)); then
        TMOUT=900
      fi

      source_file() {
        if [[ -f $1 ]]; then
          source "$1"
        fi
      }
      source_dir() {
        while IFS= read -r -d $'\0' file; do
          source_file "$file"
        done < <(find -L "$1" -type f -not -name *.swp -print0 | LC_COLLATE=C sort -dz)
      }

      source_file "$PATH_BASH_CONFIG/options"

      source_dir "$PATH_BASH_CONFIG/exports"
      source_dir "$PATH_BASH_CONFIG/utils"
      source_dir "$PATH_BASH_CONFIG/aliases"

      # override with custom completions
      source_dir "$PATH_BASH_CONFIG/completion"

      source_file "$HOME/.LESS_TERMCAP"

      if command -v starship 2>&1 | logger -t bashrc -p user.info; then
        source_file "$PATH_BASH_CONFIG/config/starship_init"
      fi
      unset source_file
      unset source_dir
    '';
  };
}
