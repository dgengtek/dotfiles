#!/usr/bin/env bash
xrandr_hd() {
    xrandr --output DisplayPort-2 --mode 1920x1080 --rate 144 --left-of DVI-D-0 --primary
    xrandr --output DVI-D-0 --mode 1920x1080 --rate 60 --pos 1920x0
}
xrandr_game() {
    xrandr --output DisplayPort-2 --mode 1600x900  --left-of DVI-D-1 --primary
    xrandr --output DVI-D-0 --auto
}
