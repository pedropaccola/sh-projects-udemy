#!/bin/bash

# This script disables, deletes, and/or archives users on the local system.

# Executed with root privileges
if [[ "${UID}" -ne 0 ]]
then
  echo "$(basename "${0}"): cannot delete user: Permission denied" 1>&2
  echo 'Please run this script with root privileges' 1>&2
  exit 1
fi

readonly ARCHIVE_DIR='/archive'

usage() {
  # Display the usage and exit
  {
    echo 'NAME'
    echo "  $(basename "${0}") - deletes an user"
    echo 'SYNOPSIS'
    echo "  $(basename "${0}") [-drav] USER_NAME [USER_NAME]..."
    echo 'DESCRIPTION'
    echo "  Disables a user account from the system. At least one USER_NAME must be provided."
    echo "  -d Delete the account instead of disabling it."
    echo "  -r Remove the home directory associates with the account(s)."
    echo "  -a Create an archive of the home directory associates with the account(s) and store the archive in the /archives directory."
    echo "  -v Verbose mode."
  } 1>&2
  exit 1
}

verbose() {
  # Print on STDOUT
  local MESSAGE
  MESSAGE="${*}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}

errormsg () {
  # Print on STDOUT
  local MESSAGE
  MESSAGE="${*}"
  echo "${MESSAGE}" 1>&2
}

# Parse the options
while getopts drav OPTION
do
  case ${OPTION} in
    d) DEL_USER='true' ;;
    r) RM_DIR='-r' ;;
    a) ARCHIVE='true' ;;
    v)
      VERBOSE='true'
      verbose 'Verbose mode on:'
      ;;
    ?) usage ;;
  esac
done
      
# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND -1 ))"

# No USER_NAME provided
if [[ "${#}" -lt 1 ]]
then
  usage
fi

# Loop through all the usernames supplied as arguments.
for USER_NAME in "${@}" 
do
  verbose "Processing user: ${USER_NAME}."

  # Make sure the account exists and the UID of the account is at least 1000.
  if ! USER_ID=$(id -u "${USER_NAME}")
  then
    errormsg "User ${USER_NAME} does not exist."
    exit 1
  elif [[ "${USER_ID}" -lt 1000 ]]
  then
    errormsg "Refusing to remove the ${USER_NAME} account with the UID ${USER_ID}."
    exit 1
  fi

  # Create an archive if requested to do so.
  if [[ "${ARCHIVE}" = 'true' ]]
  then
    verbose "Archiving the home directory from the user ${USER_NAME}."
    # Make sure the ARCHIVE_DIR directory exists, otherwise create it.
    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
      verbose "Creating the ${ARCHIVE_DIR} directory."
      # Make sure the creation of the ARCHIVE_DIR succeeds.
      if ! mkdir -p ${ARCHIVE_DIR}
      then
        errormsg "The archive directory ${ARCHIVE_DIR} could not be created." 
        exit 1
      fi
      verbose "${ARCHIVE_DIR} created."
    fi
    # Archive the user's home directory and move it into ARCHIVE_DIR
    HOME_DIR="/home/${USER_NAME}"
    ARCHIVE_FILE="${ARCHIVE_DIR}/${USER_NAME}.tgz"
    if [[ -d "${HOME_DIR}" ]]
    then
      verbose "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}."
      if ! tar -zcf "${ARCHIVE_FILE}" "${HOME_DIR}" &> /dev/null
      then
        errormsg "Could not created ${ARCHIVE_FILE}."
        exit 1
      fi
      verbose "${HOME_DIR} archived to ${ARCHIVE_FILE}."
    else
      errormsg "${HOME_DIR} does not exist or is not a directory."
      exit 1
    fi
  fi

  # Delete the user if requested to do so
  if [[ "${DEL_USER}" = 'true' ]]
  then
    verbose "Deleting the user ${USER_NAME}."
    if ! userdel "${RM_DIR}" "${USER_NAME}"
    then
      errormsg "The user ${USER_NAME} was NOT deleted."
      exit 1
    fi
    verbose "User ${USER_NAME} deleted."
  else
    # If DEL_USER is false, disable the user.
    verbose "Disabling the user ${USER_NAME}."
    if ! chage -E 0 "${USER_NAME}"
    then
      errormsg "The user ${USER_NAME} was NOT disabled."
      exit 1
    fi
    verbose "User ${USER_NAME} disabled."
  fi

done
