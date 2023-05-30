#!/bin/bash

# This script pings a list of servers and reports their status.

SERVER_FILE='./servers'

if [[ ! -e "${SERVER_FILE}" ]]; then
  echo "Cannot open ${SERVER_FILE}." 1>&2
  exit 1
fi

for SERVER in $(cat "${SERVER_FILE}"); do
  echo "Pinging ${SERVER}"
  if ! ping -c 1 "${SERVER}" &> /dev/null; then
    echo "${SERVER} down."
  else
    echo "${SERVER} is up."
  fi
done

# According to the linter #SC2013 this is the corret way to do it.
while read -r SERVER; do
  echo "Pinging ${SERVER}"
  if ! ping -c 1 "${SERVER}" &> /dev/null; then
    echo "${SERVER} down."
  else
    echo "${SERVER} is up."
  fi
done < ${SERVER_FILE}




