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
[[ -f ~/.bashrc ]] && . ~/.bashrc
