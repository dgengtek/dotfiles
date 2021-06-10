#!/bin/env bash
if [[ -f ~/.Xresources ]]; then
  xrdb -merge ~/.Xresources
fi

setxkbmap de
if [[ -f ~/.Xmodmap ]]; then
  xmodmap ~/.Xmodmap
fi

xscreensaver -nosplash &

exec nice -n -10 /usr/bin/awesome
