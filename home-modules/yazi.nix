{ config, options, lib, pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      opener = {
        open = [
          { run = ''xdg-open "$@"''; desc = "Open"; for = "linux"; }
        ];
      };
      preview = {
        image_dir = "ueberzug";
        tab_size = 2;
        max_width = 1920;
        max_height = 1080;
      };
      manager = {
        mouse_enabled = false;
      };
    };

    keymap = {
      manager.prepend_keymap = [
        { on = [ "c" "n" ]; run = ''shell "tmux neww -c \"$PWD\""''; desc = "New tmux window in current dir"; }
        { on = [ "c" "r" ]; run = ''shell "alacritty &"''; desc = "Open Alacritty"; }
        { on = [ "c" "o" ]; run = "tab_create --current"; desc = "New tab"; }
        { on = [ "s" "S" ]; run = "shell '$SHELL' --block"; desc = "Open shell"; }
        { on = [ "s" "s" ]; run = "shell --interactive"; desc = "Run shell command"; }
        { on = [ "r" "r" ]; run = "open --interactive"; desc = "Open with..."; }
        { on = [ "r" "R" ]; run = "reload"; desc = "Reload CWD"; }
        { on = [ "r" "a" ]; run = "rename --cursor=before_ext"; desc = "Bulk rename"; }
        { on = [ "f" "f" ]; run = "find --smart"; desc = "Find file"; }
        { on = [ "<C-t>" ]; run = ''shell "fzf --preview='yazi-preview {}'"''; desc = "FZF select"; }
      ];
    };
  };
}
