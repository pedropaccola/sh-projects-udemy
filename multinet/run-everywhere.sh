#!/bin/bash

# A list of servers, one per line
SERVER_LIST='./servers'

# Options for the ssh command
SSH_OPTIONS='-o ConnectTimeout=2'

usage() {
  # Display the usage and exit
  echo "Usage: $(basename "${0}") [-nsv] [-f FILE] COMMAND" 1>&2
  echo 'Executes COMMAND as a single command on every server.' 1>&2
  echo "  -f FILE  Use FILE for the list of servers. Default ${SERVER_LIST}." 1>&2
  echo '  -d       Dry run mode. Display the COMMAND that would have been executed and exit.' 1>&2
  echo '  -s       Execute the COMMAND using sudo on the remote server.' 1>&2
  echo '  -v       Verbose mode. Display the server name before executing COMMAND.' 1>&2
  exit 1
}

# Make sure the script is not executed with superuser privileges.
if [[ ${UID} -eq 0 ]]; then
  echo 'Do not execute this script as root. Use the -s option instead' 1>&2
  usage
fi

# Parse the options.

while getopts f:dsv OPTION; do
  case ${OPTION} in
    f) SERVER_LIST="${OPTARG}" ;;
    d) DRY_RUN='true' ;;
    s) SUDO='sudo' ;;
    v) VERBOSE='true' ;;
    ?) usage ;;
  esac
done

# Remove the options while leaving the remaining aguments.
shift "$(( OPTIND -1 ))"

# If the user doesn't supply at least one argument, give them help
if [[ "${#}" -lt 1 ]]; then
  usage
fi

# Anything that remains is the command.
COMMAND="${*}"

# Make sure the SERVER_LIST file exist.
if [[ ! -e "${SERVER_LIST}" ]]; then
  echo "Cannot open ${SERVER_LIST}." 1>&2
  exit 1
fi
  
# Expect the best, prepare for the worst
EXIT_STATUS='0'

# Loop through the SERVER_LIST
while read -r SERVER; do
  if [[ "${VERBOSE}" = 'true' ]]; then
    echo "${SERVER}"
  fi

  SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"

  # IF it is a dry run, don't execute, just echo it

  if [[ "${DRY_RUN}" = 'true' ]]; then
    echo "DRY RUN: ${SSH_COMMAND}"
  else
    ${SSH_COMMAND}
    SSH_EXIT_STATUS="${?}"

    # Capture any non-zero exit status from the SSH_COMMAND and report to user
    if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]; then
      EXIT_STATUS="${SSH_EXIT_STATUS}"
      echo "Execution on ${SERVER} failed" 1>&2
    fi
  fi
done < "${SERVER_LIST}"

exit ${EXIT_STATUS}
