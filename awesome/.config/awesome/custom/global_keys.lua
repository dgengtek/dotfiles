#!/bin/env lua
local values = require("custom/values")
local awful = require("awful")
modkey = values.modkey

keys = awful.util.table.join(
  -- terminal
  awful.key({ modkey,           }, "Return", function () awful.util.spawn(values.terminal_tmux) end),
  awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(values.terminal) end),

  -- sound
  awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("vol_up.sh") end),

  awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("vol_down.sh") end),

  awful.key({ }, "XF86AudioMute", function () awful.util.spawn("mute_toggle.sh") end),
  --	Screen Lock
  awful.key({ modkey, "Control" }, "-", function () awful.util.spawn("xscreensaver-command -lock") end),

  awful.key({ modkey, }, "Print", function () awful.util.spawn("screenshot.sh") end),
  awful.key({ modkey, "Control"}, "Print", function () awful.util.spawn("screenshot.sh -w") end),
  awful.key({ modkey, "Shift"}, "Print", function () awful.util.spawn("maim -s") end)
)
return keys
