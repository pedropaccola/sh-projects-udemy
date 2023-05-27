#!/bin/bash

# Display the number of failed login attempts by IP address and location.
# If there are any IPs with over LIMIT failures, display the count, IP and location

LIMIT=10
LOG_FILE=${1}

# Make sure a file was supplied as an argument.
if [[ ! -e "${1}" ]]
then
  echo "Cannot access file ${1}" 1>&2
  exit 1
fi

# Display the CSV header.
echo 'Count,IP,Location'

# Loop through the list of failed attempts and corresponding IP addresses.
grep "Failed" "${LOG_FILE}" | awk '{print $(NF - 3)}' | sort | uniq -c | sort -n -r | while read -r COUNT IP
do
  # If the number of failed attempts is greater than the limit, display count, IP and location.
  if [[ "${COUNT}" -gt "${LIMIT}" ]]
  then
    LOCATION=$(geoiplookup "${IP}" | awk -F ', ' '{print $2}' )
    echo "${COUNT},${IP},${LOCATION}"
  fi

done



