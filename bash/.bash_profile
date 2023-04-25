#
# ~/.bash_profile
#

# check if X display available
if xhost >& /dev/null ; then 
  if [[ -f ~/.Xresources ]]; then
    xrdb -merge ~/.Xresources
  fi

  setxkbmap de
  if [[ -f ~/.Xmodmap ]]; then
    xmodmap ~/.Xmodmap
  fi
fi
# loadkeys -u neoqwertz
# sudo localectl --no-convert set-keymap neoqwertz # console
# sudo localectl --no-convert set-x11-keymap de pc105 neo_qwertz # x11

# set old keymap in /etc/vconsole.conf
# KEYMAP=/usr/local/share/kbd/keymaps/de-gd-keys.map # old custom keymap
[[ -f ~/.bashrc ]] && . ~/.bashrc
