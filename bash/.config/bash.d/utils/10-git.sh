#!/usr/bin/env bash

git_commit_today() { git commit -m "autocommit - $(date +%y%m%d%H%M%S)"; }

git_stashing_required() { [[ -n "$(git status --porcelain)" ]]; }

git_unstaged_items_exist() { git diff --exit-code --quiet; }

git_untracked_files() { git ls-files --other --exclude-standard --directory --no-empty-directory | egrep -v '/$'; }
