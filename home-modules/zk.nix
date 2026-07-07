{ config, options, lib, pkgs, ... }:

let
  dir = "${config.xdg.dataHome}/repos/notizbuch";
in
{

  programs.zk = {
    enable = true;
    # This automatically manages ~/.config/zk/config.toml
    settings = {
      notebook = {
        inherit dir;
      };

      note = {
        language = "de";
        default-title = "unbenannt";
        filename = "{{id}}";
        extension = "md";
        template = "default.md";
        id-charset = "alphanum";
        id-length = 12;
        id-case = "lower";
        ignore = [ "entwurf/*" "test.md" "entwurf.md" ];
      };

      extra = {
        author = "dgeng";
      };

      group.daily = {
        paths = [ "journal/daily" ];
        note = {
          filename = "{{format-date now}}";
          template = "daily.md";
        };
      };

      format.markdown = {
        hashtags = true;
        colon-tags = true;
        multiword-tags = false;
      };

      tool = {
        editor = "nvim";
        shell = "/bin/bash";
        pager = "less -FIRX";
        fzf-preview = "bat -p --color always {-1}";
        fzf-options = "--multi";
      };

      lsp.diagnostics = {
        wiki-title = "hint";
        dead-link = "error";
      };

      filter = {
        recents = "--sort created- --created-after 'last two weeks'";
      };

      alias = {
        ls = "zk list $@";
        recent = "zk edit --sort created- --created-after 'last two weeks' --interactive";
        daily = "zk new --no-input \"$ZK_NOTEBOOK_DIR/journal/daily\"";
      };
    };
  };
  home.file.".config/zk/templates" = {
    source = ../zk/.config/zk/templates;
    recursive = true;
  };
  programs.bash.sessionVariables = {
    ZK_NOTEBOOK_DIR = dir;
  };
}
