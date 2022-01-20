#!/usr/bin/env bash
# https://github.com/junegunn/fzf/wiki/Examples
if ! hash fzf 2>&1 | logger -t bashrc -p user.info; then
  return 1
fi


_widget_history_append() {
  # from __fzf_history__
  local output;
  output=$(
  builtin fc -lnr -2147483648 |
    last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e 'BEGIN { getc; $/ = "\n\t"; $HISTCMD = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCMD - $. . "\t$_" if !$seen{$_}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m --read0" $(__fzfcmd) 
  ) || return;
  READLINE_LINE="${READLINE_LINE}${output#*$'\t'}"
}
bind -x '"\eh": _widget_history_append'


_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

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

# fco - checkout git branch/tag
f_git_checkout() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return
  git checkout $(awk '{print $2}' <<<"$target" )
}
alias f_gco=f_git_checkout


# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
f_git_checkout_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}
alias f_gcopreview=f_git_checkout_preview


f_git_checkout_commit() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}
alias f_gcoc=f_git_checkout_commit


# get commit hash
f_git_commit_hash() {
  local commits
  local commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}
alias f_ghash=f_git_commit_hash


alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"


# fcoc_preview - checkout git commit with previews
f_git_checkout_commit_preview() {
  local commit
  commit=$( glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" ) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}
alias f_gcocpreview=f_git_checkout_commit_preview


# fshow_preview - git commit browser with previews
f_git_commit_preview() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}
alias f_gcpreview=f_git_commit_preview


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

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.
f_tmux() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}
alias tm=f_tmux


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


f_history() {
  ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' \
    | perl -e 'ioctl STDOUT, 0x5412, $_ for split //, <>'
}
alias f_h=f_history


f_history_edit() {
  ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' \
    | perl -e 'ioctl STDOUT, 0x5412, $_ for split //, do{ chomp($_ = <>); $_ }'
}
alias f_he=f_history_edit


# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
f_kill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}


# fjrnl - Search JRNL headlines
f_jrnl() {                                                                                                                                                                                               
  title=$(jrnl --short | fzf --tac --no-sort) &&                                                                                                                                                         
  jrnl -on "$(echo $title | cut -c 1-16)" $1                                                                                                                                                             
  } 

f_buku() {
    # save newline separated string into an array
    mapfile -t website <<< "$(buku -p -f 5 | column -ts$'\t' | fzf --multi)"

    # open each website
    for i in "${website[@]}"; do
        index="$(echo "$i" | awk '{print $1}')"
        buku -p "$index"
        buku -o "$index"
    done
}

man-find() {
    f=$(fd . $MANPATH/man${1:-1} -t f -x echo {/.} | fzf) && man $f
}

# f_man() {
 #    man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r man
# }

fman() {
    man -k . | fzf -q "$1" --prompt='man> '  --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}


f_task() {
  task status:pending "$@" export \
    | jq -r '.[] | [.id, .description, "[[[" + ( [try .annotations[].description] | join(", ")) + "]]]", (try .tags | join(","))] | join(" ")' \
    | fzf --preview="task {1}"
}
