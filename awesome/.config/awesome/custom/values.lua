#!/bin/env lua
values = {}
values.theme_path = "/home/gd/.config/awesome/theme.lua"
values.terminal = "urxvt"
values.terminal_tmux = values.terminal .. " -e tmux "
values.editor = os.getenv("EDITOR") or "vi"
values.editor_cmd = values.terminal .. " -e " .. values.editor
values.modkey = "Mod4"
return values
