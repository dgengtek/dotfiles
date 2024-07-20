#!/usr/bin/env bash
if ! declare -f __git_complete >/dev/null 2>&1; then
	echo "Install bash-completion. Or source git completions" | logger -t bashrc -p user.info
	return
fi

__git_complete g _git_main
__git_complete gd _git_diff
__git_complete gdc _git_diff

__git_complete gco _git_checkout
__git_complete gcom _git_merge
__git_complete gcod _git_merge
__git_complete gcoundo _git_merge

__git_complete gm _git_merge
__git_complete gmffo _git_merge

__git_complete gl _git_pull
__git_complete gup _git_pull

__git_complete gp _git_push
__git_complete gpfl _git_push
__git_complete gpu _git_push

__git_complete gn _git_notes

__git_complete gc _git_commit
__git_complete 'gc!' _git_commit
__git_complete gca _git_commit
__git_complete 'gca!' _git_commit
__git_complete gcmsg _git_commit
__git_complete gcf _git_commit
__git_complete gcs _git_commit

__git_complete gr _git_remote
__git_complete grv _git_remote
__git_complete grmv _git_remote
__git_complete grrm _git_remote
__git_complete grset _git_remote
__git_complete grup _git_remote

__git_complete grb _git_rebase
__git_complete grbi _git_rebase
__git_complete grbc _git_rebase
__git_complete grba _git_rebase
__git_complete grbs _git_rebase

__git_complete grmc _git_rm

__git_complete gb _git_branch
__git_complete gbv _git_branch
__git_complete gbvv _git_branch
__git_complete gba _git_branch
__git_complete gbmm _git_branch

__git_complete gcount _git_shortlog
__git_complete gcl _git_config

__git_complete gcp _git_cherry_pick

__git_complete glg _git_log
__git_complete glgg _git_log
__git_complete glgga _git_log
__git_complete glo _git_log
__git_complete glog _git_log
__git_complete gloga _git_log
__git_complete glogs _git_log
__git_complete glsdeleted _git_log
__git_complete glsig _git_log
__git_complete glp _git_log
__git_complete glf _git_log

__git_complete gs _git_status
__git_complete gss _git_status
__git_complete gsi _git_status

__git_complete ga _git_add
__git_complete gai _git_add
__git_complete gap _git_add

__git_complete grst _git_reset
__git_complete grsth _git_reset
__git_complete gclean _git_reset

__git_complete gwc _git_whatchanged
__git_complete gwc2 _git_whatchanged

__git_complete gtracked _git_ls_files

__git_complete gmt _git_mergetool

__git_complete gst _git_stash
__git_complete gsts _git_stash
__git_complete gstp _git_stash
__git_complete gstd _git_stash
