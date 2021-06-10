#!/usr/bin/env bash
if ! hash fzf 2>&1 | logger -t bashrc -p user.info; then
  return 1
fi


f() {
  local dir
  if [[ -z $1 ]]; then
    dir="."
  else
    dir=$1
    shift
  fi
  if ! pushd "$dir" 2>&1 >/dev/null; then
    echo "Could not push to directory '$dir'" >&2 
    return 1
  fi
  local -r files=$(fzf "$@")
  for file in "${files[@]}"; do
    [[ -z "$file" ]] && continue
    realpath -e "$file"
  done
  popd 2>&1 >/dev/null
}


f_search_command() {
  if [[ -z $1 ]] || [[ -z $2 ]]; then
    cat >&2 << EOF
Usage: $FUNCNAME <command> <pattern>

Specify a <command> to run your results against.
Specify a <pattern> to search for.
EOF
    return 1
  fi
  local -r cmd=$1
  local -r pattern=$2
  local files=($(__find_pattern "$pattern" | fzf --multi --select-1 --exit-0))
  [[ -n "$files" ]] && $cmd "${files[@]}"
}
alias f_sc=f_search_command


f_search_preview() {
  if [[ -z $1 ]]; then
    echo "Specify a pattern to search for." >&2
    return 1
  fi
  if [[ -z $2 ]]; then
    echo "Specify a command to preview your results." >&2
    return 1
  fi
  local -r pattern=$1
  shift 1

  local files
  files=($(__find_pattern "$pattern" | fzf --preview="$@ {}" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && echo "${files[@]}"
}
alias f_sp=f_search_preview


f_preview() {
  if [[ -z $1 ]]; then
    echo "Specify a command to preview your results." >&2
    return 1
  fi
  local files
  files=($(fzf --preview="$@ {}" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && echo "${files[@]}"
}
alias f_p=f_preview


unalias z 2> /dev/null
z() {
  local PATH_BOOKMARKS=${PATH_BOOKMARKS:-"${HOME}/.local/share/"}
  local -r FSBOOKMARKS="${PATH_BOOKMARKS}fsbookmarks.db.txt"
  local -r result=$(sort "$FSBOOKMARKS" | fzf)
  [[ -z $result ]] && return 0
  if ! [[ -d $result ]]; then
    fsbookmark.sh del "$result"
    echo "$result is not a directory. Removed from $FSBOOKMARKS" >&2
    return 0
  fi
  echo -n "$result"
}


zz() {
  local -r dir="$(z)"
  if [[ -n "$dir" ]]; then
    builtin cd "$dir"
  fi
}


f_edit() {
  # edit selected files
  local files=
  IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}
alias f_e=f_edit


f_change_directory() {
# fd - cd to selected directory
  local dir
  dir=$(find_dir_prune_hidden "$@" | fzf --no-multi) && builtin cd "$dir"
}
alias f_cd=f_change_directory


f_change_directory_depth() {
# fd - cd to selected directory
  local dir
  dir=$(find_dir_depth_prune_hidden "$@" | fzf --no-multi) && builtin cd "$dir"
}
alias f_cdd=f_change_directory_depth


f_cd1() {
  local topath=$1
  shift
  f_change_directory_depth "$topath" 0 1 "$@"
}
alias f_cdcwd=f_cd1


f_cd2() {
  local topath=$1
  shift
  f_change_directory_depth "$topath" 0 2 "$@"
}


f_change_directory_hidden() {
# fda - including hidden directories
  local dir
  dir=$(find_dir "$@" | fzf --no-multi) && builtin cd "$dir"
}
alias f_cdh=f_change_directory_hidden


f_change_directory_depth_hidden() {
# fda - including hidden directories
  local dir
  dir=$(find_dir_depth "$@" | fzf --no-multi) && builtin cd "$dir"
}
alias f_cddh=f_change_directory_hidden


f_cddh1() {
  local topath=$1
  shift
  f_change_directory_depth_hidden "$topath" 0 1 "$@"
}


f_cddh2() {
  local topath=$1
  shift
  f_change_directory_depth_hidden "$topath" 0 2 "$@"
}


f_search_directory() {
  local dir
  dir=$(find ${1:-.} -not -path '*/\.*' -type d | fzf +m)
  echo "$dir"
}
alias f_sd=f_search_directory


f_search_directory_hidden() {
  local dir
  dir=$(find ${1:-.} -type d | fzf +m)
  echo "$dir"
}
alias f_sdh=f_search_directory_hidden



f_change_directory_parent() {
  # cd to selected parent
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  builtin cd "$DIR"
}
alias f_cdp=f_change_directory_parent


# fkill - kill process
f_kill() {
  local pid
  pid=$(ps -eo pid,ppid,user,group,euser,egroup,nice,s,cmd --sort=cmd | sed -e 's,^[ ]*,,' | fzf -m | awk '{print $1}')
  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-SIGINT}
  fi
}


f_git_checkout_branches() {
  # checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
alias f_gcob=f_git_checkout_branches


f_git_checkout() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD |
    sed "s/.* //" | sed "s#remotes/[^/]*/##" |
    sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}
alias f_gco=f_git_checkout


f_git_checkout_commit() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}
alias f_gcoc=f_git_checkout_commit


f_git_commit_browser() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}
alias f_gbrowser=f_git_commit_browser


f_git_cherry_pick() {
  # pick stage files with a specific state
  # same as git add -i but shows diff in preview window
  if [[ -z $1 ]]; then
    cat >&2 << EOF
Usage: $FUNCNAME <state>
EOF
    echo "Missing git state input for \$1. [M,D,?,...]" >&2
    return
  fi
  local state=$(echo $1 | tr [:lower:] [:upper:])

  local files=
  files=($(git status -s | awk '/^[? ]['"$state"']/ {print $2}' | fzf --multi --select-1 --exit-0 --preview="git diff {}")) 
  [[ -n $files ]] && git add "${files[@]}"
}
alias f_gcherry=f_git_cherry_pick


f_git_commit_hash() {
  # get commit hash
  local commits
  local commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}
alias f_ghash=f_git_commit_hash


__f_tmux_get_session() { tmux list-sessions -F "#{session_name}" | fzf --query="$1" --select-1 --exit-0; }


f_tmuxa() {
  local -r session=$(__f_tmux_get_session)
  tmux attach -t "$session"
}


f_tmuxs() {
  local -r session=$(__f_tmux_get_session)
  tmux switch-client -t "$session"
}


f_tmuxneww() {
  local -r dir=$(find_dir_depth "$@" | fzf +m)
  [[ -z $dir ]] && return
  builtin cd "$dir"
  tmux neww -n "$(basename $dir)"
  builtin cd -
}


if hash mpc 2>&1 | logger -t bashrc -p user.info; then
f_mpc() {
  local -r filename=$(mpc playlist | \
    fzf-tmux --query="$1" --reverse --select-1)
  [[ -n "$filename" ]] && mpc searchplay filename "$filename"
}
fi


# create a new shell
f_shell_new() {
  local -r dir=$(find_dir "$1" | fzf +m)
  [[ -z $dir ]] && return
  shift
  run.sh -s -- alacritty --working-directory "$(realpath $dir)" "$@"
}
alias f_shn=f_shell_new


# create a new shell with a tmux session
f_shell_tmux_new() {
  local -r dir=$(find_dir "$1" | fzf +m)
  [[ -z $dir ]] && return
  shift
  local session_name
  if [[ -z $1 ]]; then
    session_name=$(basename $dir)
  else
    session_name=$(basename $1)
    shift
  fi
  session_name=$(filename_canonize.py -nl "$session_name")
  run.sh -s -- alacritty --working-directory "$(realpath $dir)" -e "tmux new -s $session_name"
}
alias f_shtmuxn=f_shell_tmux_new


f_tmsu_tags_multi() {
  tmsu tags | fzf -m
}

f_tmsu_files() {
  tmsu files "$(f_tmsu_tags_multi)"
}
alias ftmsuf=f_tmsu_files


f_tmsu_preview() {
  local -a tags
  local tmsu_command=""
  local tmsu_tag=$(tmsu tags | fzf --preview="tmsu files {}" --select-1 --exit-0)
  [[ -z "$tmsu_tag" ]] && return 1
  while [[ -n "$tmsu_tag" ]]; do
    tags+=("$tmsu_tag")
    tmsu_command="tmsu files ${tags[*]}"
    tmsu_tag=($(tmsu tags | fzf --preview="$tmsu_command {}" --select-1 --exit-0))
  done
  tmsu files "${tags[@]}"
}
alias ftmsup=f_tmsu_preview
