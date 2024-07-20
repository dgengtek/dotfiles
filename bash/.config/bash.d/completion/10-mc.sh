if command -v mc 2>&1 | logger -t bash -p user.info; then
	complete -C /usr/bin/mc mc
fi
