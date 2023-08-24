#!/usr/bin/env bash
# @file      ping_till_alive.sh
# @author    Ignacio Vizzo     [ivizzo@uni-bonn.de]
#
# Copyright (c) 2020 Ignacio Vizzo, all rights reserved
#
# NOTE: This script only works for hostname as inputs, do not try it with ip-addresses,because it
# will not work
set -e
HOST="pi"

# If hostname does not exists exit inmediatly
getent hosts ${HOST} 1>/dev/null || (echo "[ERROR] $HOST does not exists" && exit 1)

# Enter infinite-loop, until the host becomes alive
printf "%s" "ping ${HOST} until it becomes alive"
while ! timeout 1 ping -c 1 -n $HOST &>/dev/null; do
  printf "%c" "."
  sleep 1
done
printf "\n%s\n" "${HOST} is online"
