#!/bin/env bash
function_list=$(compgen -c | sort -u)

result=$(echo "$function_list" | fzf --no-sort)
echo "$result" >> results.txt
$($result) &
