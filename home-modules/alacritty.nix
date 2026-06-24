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
        { chars = "\\f"; key = "L"; mods = "Control"; }
        { chars = "\\u001BOH"; key = "Home"; mode = "AppCursor"; }
        { chars = "\\u001B[H"; key = "Home"; mode = "~AppCursor"; }
        { chars = "\\u001BOF"; key = "End"; mode = "AppCursor"; }
        { chars = "\\u001B[F"; key = "End"; mode = "~AppCursor"; }
        { action = "ScrollPageUp"; key = "PageUp"; mode = "~Alt"; mods = "Shift"; }
        { chars = "\\u001B[5;2~"; key = "PageUp"; mode = "Alt"; mods = "Shift"; }
        { chars = "\\u001B[5;5~"; key = "PageUp"; mods = "Control"; }
        { chars = "\\u001B[5~"; key = "PageUp"; }
        { action = "ScrollPageDown"; key = "PageDown"; mode = "~Alt"; mods = "Shift"; }
        { chars = "\\u001B[6;2~"; key = "PageDown"; mode = "Alt"; mods = "Shift"; }
        { chars = "\\u001B[6;5~"; key = "PageDown"; mods = "Control"; }
        { chars = "\\u001B[6~"; key = "PageDown"; }
        { chars = "\\u001B[Z"; key = "Tab"; mods = "Shift"; }
        { chars = "\\u007F"; key = "Back"; }
        { chars = "\\u001B\\u007F"; key = "Back"; mods = "Alt"; }
        { chars = "\\u001B[2~"; key = "Insert"; }
        { chars = "\\u001B[3~"; key = "Delete"; }
        { chars = "\\u001B[1;2D"; key = "Left"; mods = "Shift"; }
        { chars = "\\u001B[1;5D"; key = "Left"; mods = "Control"; }
        { chars = "\\u001B[1;3D"; key = "Left"; mods = "Alt"; }
        { chars = "\\u001B[D"; key = "Left"; mode = "~AppCursor"; }
        { chars = "\\u001BOD"; key = "Left"; mode = "AppCursor"; }
        { chars = "\\u001B[1;2C"; key = "Right"; mods = "Shift"; }
        { chars = "\\u001B[1;5C"; key = "Right"; mods = "Control"; }
        { chars = "\\u001B[1;3C"; key = "Right"; mods = "Alt"; }
        { chars = "\\u001B[C"; key = "Right"; mode = "~AppCursor"; }
        { chars = "\\u001BOC"; key = "Right"; mode = "AppCursor"; }
        { chars = "\\u001B[1;2A"; key = "Up"; mods = "Shift"; }
        { chars = "\\u001B[1;5A"; key = "Up"; mods = "Control"; }
        { chars = "\\u001B[1;3A"; key = "Up"; mods = "Alt"; }
        { chars = "\\u001B[A"; key = "Up"; mode = "~AppCursor"; }
        { chars = "\\u001BOA"; key = "Up"; mode = "AppCursor"; }
        { chars = "\\u001B[1;2B"; key = "Down"; mods = "Shift"; }
        { chars = "\\u001B[1;5B"; key = "Down"; mods = "Control"; }
        { chars = "\\u001B[1;3B"; key = "Down"; mods = "Alt"; }
        { chars = "\\u001B[B"; key = "Down"; mode = "~AppCursor"; }
        { chars = "\\u001BOB"; key = "Down"; mode = "AppCursor"; }
        { chars = "\\u001BOP"; key = "F1"; }
        { chars = "\\u001BOQ"; key = "F2"; }
        { chars = "\\u001BOR"; key = "F3"; }
        { chars = "\\u001BOS"; key = "F4"; }
        { chars = "\\u001B[15~"; key = "F5"; }
        { chars = "\\u001B[17~"; key = "F6"; }
        { chars = "\\u001B[18~"; key = "F7"; }
        { chars = "\\u001B[19~"; key = "F8"; }
        { chars = "\\u001B[20~"; key = "F9"; }
        { chars = "\\u001B[21~"; key = "F10"; }
        { chars = "\\u001B[23~"; key = "F11"; }
        { chars = "\\u001B[24~"; key = "F12"; }
        { chars = "\\u001B[1;2P"; key = "F1"; mods = "Shift"; }
        { chars = "\\u001B[1;2Q"; key = "F2"; mods = "Shift"; }
        { chars = "\\u001B[1;2R"; key = "F3"; mods = "Shift"; }
        { chars = "\\u001B[1;2S"; key = "F4"; mods = "Shift"; }
        { chars = "\\u001B[15;2~"; key = "F5"; mods = "Shift"; }
        { chars = "\\u001B[17;2~"; key = "F6"; mods = "Shift"; }
        { chars = "\\u001B[18;2~"; key = "F7"; mods = "Shift"; }
        { chars = "\\u001B[19;2~"; key = "F8"; mods = "Shift"; }
        { chars = "\\u001B[20;2~"; key = "F9"; mods = "Shift"; }
        { chars = "\\u001B[21;2~"; key = "F10"; mods = "Shift"; }
        { chars = "\\u001B[23;2~"; key = "F11"; mods = "Shift"; }
        { chars = "\\u001B[24;2~"; key = "F12"; mods = "Shift"; }
        { chars = "\\u001B[1;5P"; key = "F1"; mods = "Control"; }
        { chars = "\\u001B[1;5Q"; key = "F2"; mods = "Control"; }
        { chars = "\\u001B[1;5R"; key = "F3"; mods = "Control"; }
        { chars = "\\u001B[1;5S"; key = "F4"; mods = "Control"; }
        { chars = "\\u001B[15;5~"; key = "F5"; mods = "Control"; }
        { chars = "\\u001B[17;5~"; key = "F6"; mods = "Control"; }
        { chars = "\\u001B[18;5~"; key = "F7"; mods = "Control"; }
        { chars = "\\u001B[19;5~"; key = "F8"; mods = "Control"; }
        { chars = "\\u001B[20;5~"; key = "F9"; mods = "Control"; }
        { chars = "\\u001B[21;5~"; key = "F10"; mods = "Control"; }
        { chars = "\\u001B[23;5~"; key = "F11"; mods = "Control"; }
        { chars = "\\u001B[24;5~"; key = "F12"; mods = "Control"; }
        { chars = "\\u001B[1;6P"; key = "F1"; mods = "Alt"; }
        { chars = "\\u001B[1;6Q"; key = "F2"; mods = "Alt"; }
        { chars = "\\u001B[1;6R"; key = "F3"; mods = "Alt"; }
        { chars = "\\u001B[1;6S"; key = "F4"; mods = "Alt"; }
        { chars = "\\u001B[15;6~"; key = "F5"; mods = "Alt"; }
        { chars = "\\u001B[17;6~"; key = "F6"; mods = "Alt"; }
        { chars = "\\u001B[18;6~"; key = "F7"; mods = "Alt"; }
        { chars = "\\u001B[19;6~"; key = "F8"; mods = "Alt"; }
        { chars = "\\u001B[20;6~"; key = "F9"; mods = "Alt"; }
        { chars = "\\u001B[21;6~"; key = "F10"; mods = "Alt"; }
        { chars = "\\u001B[23;6~"; key = "F11"; mods = "Alt"; }
        { chars = "\\u001B[24;6~"; key = "F12"; mods = "Alt"; }
        { chars = "\\u001B[1;3P"; key = "F1"; mods = "Super"; }
        { chars = "\\u001B[1;3Q"; key = "F2"; mods = "Super"; }
        { chars = "\\u001B[1;3R"; key = "F3"; mods = "Super"; }
        { chars = "\\u001B[1;3S"; key = "F4"; mods = "Super"; }
        { chars = "\\u001B[15;3~"; key = "F5"; mods = "Super"; }
        { chars = "\\u001B[17;3~"; key = "F6"; mods = "Super"; }
        { chars = "\\u001B[18;3~"; key = "F7"; mods = "Super"; }
        { chars = "\\u001B[19;3~"; key = "F8"; mods = "Super"; }
        { chars = "\\u001B[20;3~"; key = "F9"; mods = "Super"; }
        { chars = "\\u001B[21;3~"; key = "F10"; mods = "Super"; }
        { chars = "\\u001B[23;3~"; key = "F11"; mods = "Super"; }
        { chars = "\\u001B[24;3~"; key = "F12"; mods = "Super"; }
        { chars = "\\n"; key = "NumpadEnter"; }
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
