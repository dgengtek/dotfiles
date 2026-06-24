{ config, options, lib, inputs, pkgs, system, ... }:
let
  colors = inputs.ops-vars.vars.${system}.colors.kanagawa_wave;
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      general.live_config_reload = false;

      bell = {
        animation = "EaseOutExpo";
        color = "0xffffff";
        duration = 0;
      };

      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = colors.bg;
          foreground = colors.fg;
        };
        normal = {
          inherit (colors) black red green yellow blue magenta cyan white;
        };
        bright = {
          black = colors.brightBlack;
          red = colors.brightRed;
          green = colors.brightGreen;
          yellow = colors.brightYellow;
          blue = colors.brightBlue;
          magenta = colors.brightMagenta;
          cyan = colors.brightCyan;
          white = colors.brightWhite;
        };
        selection = {
          background = colors.selectionBg;
          foreground = colors.selectionFg;
        };
        indexed_colors = [
          { index = 16; color = colors.extra16; }
          { index = 17; color = colors.extra17; }
        ];
      };

      cursor = {
        style.shape = "Block";
        unfocused_hollow = true;
      };

      debug = {
        persistent_logging = false;
        render_timer = false;
      };

      env = {
        TERM = "alacritty";
        COLORTERM = "truecolor";
      };

      font = {
        size = 16.0;
        normal = { family = "Terminess Nerd Font"; style = "Regular"; };
        bold = { family = "Terminess Nerd Font"; style = "Bold"; };
        italic = { family = "Terminess Nerd Font"; style = "Italic"; };
      };

      keyboard.bindings = [
        { action = "Paste"; key = "V"; mods = "Control|Alt"; }
        { action = "Copy"; key = "C"; mods = "Control|Alt"; }
        { action = "PasteSelection"; key = "Insert"; mods = "Shift"; }
        { action = "Paste"; key = "Paste"; }
        { action = "Copy"; key = "Copy"; }
        { action = "ClearLogNotice"; key = "L"; mods = "Control"; }
      ];

      mouse.bindings = [
        { action = "PasteSelection"; mouse = "Middle"; }
      ];

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      selection = {
        save_to_clipboard = true;
        semantic_escape_chars = ",│`|:\"' ()[]{}<>";
      };

      window = {
        decorations = "full";
        dynamic_padding = false;
        dynamic_title = true;
        opacity = 1.0;
        startup_mode = "Maximized";
        dimensions = { columns = 0; lines = 0; };
        padding = { x = 2; y = 2; };
      };
    };
  };
}
