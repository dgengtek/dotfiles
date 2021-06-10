#!/usr/bin/env bash
if ! hash pass 2>&1 | logger -t bashrc -p user.info; then
  return 1
fi
[[ -z $PASSWORD_STORE_DIR ]] && echo "Please set PASSWORD_STORE_DIR export variable for pass" >&2 && return 1
__f_pass_find() {
  pushd "$PASSWORD_STORE_DIR" >& /dev/null
  local file=$(find_file . -not -path "./.git/*" -name "*.gpg" | sed 's,\.gpg$,,' | fzf --no-multi --select-1)
  echo -n "$file"
  popd >& /dev/null
}
__f_pass_find_echo() {
  pushd "$PASSWORD_STORE_DIR" >& /dev/null
  local file=$(find_file . -not -path "./.git/*" -name "*.gpg" | sed 's,\.gpg$,,' | fzf --no-multi --select-1)
  echo -n "$file"
  popd >& /dev/null
}

f_pass_show() {
  local rc=0
  local file=$(__f_pass_find)
  if [[ -n $file ]]; then
    if [[ -n "$DISPLAY" ]]; then
      [[ -z $1 ]] && set -- -c1
      pass show "$@" "$file"
    else
      local -r tmux_buffer_name="clipboard"
      tmux set-buffer -b "$tmux_buffer_name" "$(pass show $@ $file)" || rc=1
      echo "use 'tmux show-buffer -b $tmux_buffer_name' or tmux-prefix + p to paste" >&2
    fi
  else
    rc=1
  fi
  return $rc
}

passshow() {
  local rc=0
  local file=$(__f_pass_find)
  if [[ -n $file ]]; then
    pass show "$@" "$file"
  else
    rc=1
  fi
  return $rc
}
alias pw=passshow

f_pass_login() {
  local file=$(__f_pass_find_echo)
  if [[ $? != 0 ]]; then
    echo "Error in finding any result." >&2 
    return 1
  elif [[ -z $file ]]; then
    echo "Empty result." >&2
    return 1
  fi
  local -r data=$(pass show "$file")
  echo "Copying username." >&2
  local username=$(echo -n "$data" | awk -F: '/user/{gsub(/ /,"",$2);print $2}')
  if [[ -z $username ]]; then
    echo "No username in data." >&2
    return 1
  fi
  echo -n "$username" | xclip -selection clipboard -i
  read -p "Press enter to copy pass"
  echo -n "$data" | sed -n 1p | xclip -selection clipboard -i
  echo "clearing in 10secs"
  sleep 10 && echo -n "empty" | xclip -selection clipboard -i &
}
alias pws=f_pass_show
alias pwsl=f_pass_login

f_pass_rm() {
  local path=$(__f_pass_find)
  if [[ -d $path ]]; then
    pass rm "$@" -r "$path"
  else
    pass rm "$@" "$path"
  fi
}
alias pwrm=f_pass_rm

f_pass_ls() {
  local path=$(find "$PASSWORD_STORE_DIR" -type d -print0 | fzf --no-multi --select-1 --read0)
  ls "$@" "$path"
}
alias pwls=f_pass_ls

f_pass_edit() {
  pushd "$PASSWORD_STORE_DIR" >& /dev/null
  while read -d $'\n' file; do
    file=${file##./}
    file=${file%%.gpg}
    # requires to input /dev/tty else terminal will break, since the controlling
    #  terminal is not the same as the invoking
    pass edit "$file" < /dev/tty
  done < <(find . -type f -print0 | fzf --multi --select-1 --read0)
  popd >& /dev/null
}
alias pwedit=f_pass_edit

f_pass_insert() {
  pushd "$PASSWORD_STORE_DIR" >& /dev/null
  while read -d $'\n' file; do
    file=${file##./}
    file=${file%%.gpg}
    # requires to input /dev/tty else terminal will break, since the controlling
    #  terminal is not the same as the invoking
    pass insert "$file" < /dev/tty
  done < <(find . -type f -print0 | fzf --select-1 --read0)
  popd >& /dev/null
}
alias pwi=f_pass_insert
