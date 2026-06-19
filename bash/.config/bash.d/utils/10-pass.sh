#!/usr/bin/env bash
if ! command -v pass 2>&1 | logger -t bashrc -p user.info; then
  return 1
fi
[[ -z $PASSWORD_STORE_DIR ]] && echo "Please set PASSWORD_STORE_DIR export variable for pass" >&2 && return 1
__f_pass_find() {
  pushd "$PASSWORD_STORE_DIR" >&/dev/null || exit 99
  local file
  file=$(find_file . -not -path "./.git/*" -name "*.gpg" | sed 's,\.gpg$,,' | fzf --no-multi --select-1)
  echo -n "$file"
  popd >&/dev/null || exit 99
}

__f_pass_find_echo() {
  pushd "$PASSWORD_STORE_DIR" >&/dev/null || exit 99
  local file
  file=$(find_file . -not -path "./.git/*" -name "*.gpg" | sed 's,\.gpg$,,' | fzf --no-multi --select-1)
  echo -n "$file"
  popd >&/dev/null || exit 99
}

__is_filetype() {
  if ! command -v nu 2>&1 | logger -t bashrc -p user.info; then
    return 1
  fi
  nu --stdin -c "from $1 | describe" | rg -q "^record"
}

alias __is_yaml="__is_filetype yaml"

f_show_password() {
  local rc=0
  local -r data=$(pass_show "$@")
  local result=""
  if echo "$data" | __is_yaml; then
    result=$(echo "$data" | nu --stdin --no-newline -c "from yaml | get password")
  else
    result=$(echo "$data" | sed -n 1p)
  fi

  if [[ -n "$DISPLAY" ]]; then
    echo -n "$result" | xclip -selection clipboard -i
    (sleep 10 && echo -n "empty" | xclip -selection clipboard -i &)
  else
    local -r tmux_buffer_name="clipboard"
    tmux set-buffer -b "$tmux_buffer_name" "$result" || rc=1
    echo "use 'tmux show-buffer -b $tmux_buffer_name' or tmux-prefix + p to paste" >&2
  fi

  return "$rc"
}

pass_show() {
  local -r file=$(__f_pass_find)
  [[ -z "$file" ]] && return 1
  pass show "$@" "$file"
}
alias pw=pass_show

pass_show_data() {
  # display all information except the password
  local -r data=$(pass_show "$@")
  [[ -z "$data" ]] && return 1

  if echo -n "$data" | __is_yaml; then
    echo "$data" | nu --stdin --no-newline -c "from yaml | reject password"
  else
    echo -n "$data" | sed 1d
  fi
}
alias pwdata=pass_show_data

f_pass_login() {
  local file
  file=$(__f_pass_find_echo)
  if [[ $? != 0 ]]; then
    echo "Error in finding any result." >&2
    return 1
  elif [[ -z $file ]]; then
    echo "Empty result." >&2
    return 1
  fi
  local -r data=$(pass show "$file")
  echo "Copying username." >&2
  local username=""
  local is_yaml=0
  echo "$data" | __is_yaml && is_yaml=1
  if ((is_yaml)); then
    username=$(echo -n "$data" | nu --stdin --no-newline -c "from yaml | get username")
  else
    username=$(echo -n "$data" | awk -F: '/user/{gsub(/ /,"",$2);print $2}')
  fi
  if [[ -z $username ]]; then
    echo "No username in data." >&2
    return 1
  fi
  echo -n "$username" | xclip -selection clipboard -i
  read -r -p "Press enter to copy password"

  if ((is_yaml)); then
    echo -n "$data" | nu --stdin --no-newline -c "from yaml | get password" | xclip -selection clipboard -i
  else
    echo -n "$data" | sed -n 1p | xclip -selection clipboard -i
  fi
  echo "clearing in 10secs" >&2
  (sleep 10 && echo -n "empty" | xclip -selection clipboard -i &)
}
alias pwp=f_show_password
alias pwlogin=f_pass_login

f_pass_rm() {
  local path
  path=$(__f_pass_find)
  if [[ -d $path ]]; then
    pass rm "$@" -r "$path"
  else
    pass rm "$@" "$path"
  fi
}
alias pwrm=f_pass_rm

f_pass_ls() {
  local path
  path=$(find "$PASSWORD_STORE_DIR" -type d -print0 | fzf --no-multi --select-1 --read0)
  ls "$@" "$path"
}
alias pwls=f_pass_ls

f_pass_edit() {
  pushd "$PASSWORD_STORE_DIR" >&/dev/null || exit 99
  while read -d $'\n' file; do
    file=${file##./}
    file=${file%%.gpg}
    # requires to input /dev/tty else terminal will break, since the controlling
    #  terminal is not the same as the invoking
    pass edit "$file" </dev/tty
  done < <(find . -type f -print0 | fzf --multi --select-1 --read0)
  popd >&/dev/null || exit 99
}
alias pwedit=f_pass_edit

f_pass_insert() {
  pushd "$PASSWORD_STORE_DIR" >&/dev/null || exit 99
  while read -d $'\n' file; do
    file=${file##./}
    file=${file%%.gpg}
    # requires to input /dev/tty else terminal will break, since the controlling
    #  terminal is not the same as the invoking
    pass insert "$file" </dev/tty
  done < <(find . -type f -print0 | fzf --select-1 --read0)
  popd >&/dev/null || exit 99
}
alias pwi=f_pass_insert
