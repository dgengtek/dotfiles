#!/usr/bin/env bash

salt_pgp() {
  # default user which has the gpg key for encrypting secrets
  local user=salt
  systemd-ask-password | gpg --armor --batch --trust-model always --encrypt -r "$user"
}
