#!/bin/env bash
xscreensaver -nosplash &
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
systemctl --user import-environment DISPLAY
exec nice -n -10 /usr/bin/i3
