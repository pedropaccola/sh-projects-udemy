#!/bin/bash

# Display the top three most visited URLs for a given web server log file.

LOG_FILE="${1}"

if [[ ! -e "${LOG_FILE}" ]]
then
  echo "Cannot open ${LOG_FILE}" 1>&2
  exit 1
fi

awk '{print $7}' "${LOG_FILE}" | sort | uniq -c | sort -n | tail -3

