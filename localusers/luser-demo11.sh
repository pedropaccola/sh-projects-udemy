#!/bin/bash

# This script generates a random password.
# This user can set the password length with -l and add
# a special character with -s.
# Verbose mode can be enabled with -v.

# 
usage() {
  echo "Usage: $(basename "${0}") [-vs] [-l LENGTH]"
  echo 'Generate a random password.'
  echo '  -l LENGTH Specify the password length.'
  echo '  -s        Append a special character to the password.'
  echo '  -v        Increase verbosity.'
  exit 1
}

verbatim() {
  local MESSAGE
  MESSAGE="${*}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}

# Set a default value for password length
LENGTH=48

while getopts vl:s OPTION
do 
  case ${OPTION} in
    v)
      VERBOSE='true'
      verbatim 'Verbose mode on'
      ;;
    l)
      LENGTH="${OPTARG}"
      ;;
    s)
      USE_SPECIAL_CHARACTER='true'
      ;;
    ?)
      usage
      ;;
  esac
done

verbatim 'Generating a password'
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c "${LENGTH}")

# Append a special character if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
  verbatim 'Selecting a random special character.'
  SPECIAL_CHARACTER=$(echo '!@#$%^&*()-+=' | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

verbatim 'Done.'
verbatim 'Here is the password:'

# Display the password.
echo "${PASSWORD}"

