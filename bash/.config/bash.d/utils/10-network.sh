#!/usr/bin/env bash
nc_ssh() {
  nc -vz -w 10 "$@" 22
}

pingg() { 
  ping -c 5 $(ipgateway); 
}

http_server_list() {
  local -r port=${1:-8888}
  python3 -m http.server "$port"
}
