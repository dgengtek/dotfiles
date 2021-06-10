#!/bin/env lua
local values = require("custom/values")
local awful = require("awful")
menus = {}

menus.media = {
  { "Calibre", "calibre" },
  { "vlc", "vlc" },
  { "smplayer", "smplayer" },
  { "Avidemux", "avidemux2_gtk" },
  { "Audacity", "audacity" },
  { "gtkpod", "gtkpod" },
  { "cmus", values.terminal .. " -e cmus"},
}

menus.internet = {
  { "chromium", "chromium" },
  { "firefox", "firefox" },
  { "Tor-browser", "tor-browser-en" },
  { "Thunderbird", "thunderbird" },
  { "Claws-Mail", "claws-mail" },
}

menus.development = {
  { "IntelliJ", "idea" },
  { "PyCharm", "pycharm" },
  { "Android-Studio", "android-studio" },
  { "Mindmap freeplane", "freeplane" },
  { "YEd", "yed" },
}

menus.admin = {
  { "Seahorse gpg keys management", "seahorse" },
  { "Virtualbox", "virtualbox" },
  { "Wireshark", "wireshark" },
  { "Qemu", "qemu" },
  { "keepassx", "keepassx" },
  { "lxappearance", "lxappearance" },
}

menus.others = {
  { "TimeTrack_Hamster", "hamster" },
  { "Homebank", "homebank" },
  { "Anki - memorization helper", "anki" },
  { "tipp10", "tipp10" },
}

menus.root = {
  { "leafpad", "leafpad" },
  { "Xournal", "xournal" },
  { "VIM", values.terminal .. " -e vim" },
  { "Media", menus.media},
  { "Internet", menus.internet},
  { "Dev", menus.development},
  { "Admin", menus.admin},
  { "Others", menus.others},
}

menus.terminal = {
  { "tmux urxvt", values.terminal .. " -e tmux "},
  { "urxvt terminal", values.terminal },
}

menus.myawesomemenu = {
  { "manual", values.terminal .. " -e man awesome" },
  { "File explorer", "xfe" },
  { "edit config", values.editor_cmd .. " " .. awesome.conffile },
  { "HZ_Resolution", resolution.switchHZ(awful.util.spawn)},
  { "HD_Resolution", resolution.switchHD(awful.util.spawn)},
  { "restart", awesome.restart },
  { "quit", awesome.quit },
}

menus.mainmenu = awful.menu({ 
  items = { 
    { "awesome", menus.myawesomemenu},
    { "Programs",menus.root},
    { "Terminal", menus.terminal},
  }
})

menus.launcher = awful.widget.launcher({ 
  image = "replacethis",
  menu = menus.mainmenu
})
return menus
