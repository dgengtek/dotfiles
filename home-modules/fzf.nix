{ config, options, lib, pkgs, ... }:
{
  home.packages = [
    pkgs.bat
    pkgs.fd
  ];
  programs.bash.sessionVariables = {
    FZF_COMPLETION_OPTS = "--preview 'if test -f {}; then bat --color=always --style=numbers --line-range=:500 {}; else tree -C {} | head -200;fi'";
    FZF_TMUX_HEIGHT = "100%";
  };
  programs.fzf = {
    enable = true;
    changeDirWidgetCommand = "fd --type d --min-depth 1 --hidden --follow --no-ignore-vcs --exclude '.git'";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    fileWidgetCommand = "fd --min-depth 1 --hidden --follow --no-ignore-vcs --exclude '.git'";
    fileWidgetOptions = [
      "--preview 'if test -f {}; then bat --color=always --style=numbers --line-range=:500 {}; else tree -C {} | head -200;fi'"
    ];

    defaultCommand = "fd --type f --hidden --follow --exclude '.git'";
    defaultOptions = [ "--bind alt-p:accept" ];
    enableBashIntegration = true;
    colors = {
      bg = "#000000";
      "bg+" = "#000000";
      fg = "#cccccc";
      "fg+" = "#ffffff";
      hl = "#de382b";
      "hl+" = "#ff0000";
      info = "#9a9a9a";
      prompt = "#007acc";
      pointer = "#ff0000";
      marker = "#39b54a";
      spinner = "#9a9a9a";
      header = "#9a9a9a";
    };

  };
}
