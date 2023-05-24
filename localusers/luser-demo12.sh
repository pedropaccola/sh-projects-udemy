#!/bin/bash

# This script deletes a user.

# Run as root.

if [[ "${UID}" -ne 0 ]]
then
  echo 'Please run with root privileges.' 1>&2
  exit 1
fi

# Assume the first argument is the user to delete
USER="${1}"

userdel "${USER}"

# if ! userdel "${USER}"
if [[ "${?}" -ne 0 ]]
then
  echo "The account ${USER} was NOT deleted." 1>&2
  exit 1
fi

# Tell the user the account was deleted.
echo "The account ${USER} was deleted."
