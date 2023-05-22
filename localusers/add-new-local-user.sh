#!/bin/bash

# Set bold variables
BOLD=$(tput bold)
OFFBOLD=$(tput sgr0)

# Script must be executed by a user with root privileges
# otherwise it will return with an exit status of 1.
if [[ "${UID}" -ne 0 ]]
then
    echo "${BOLD}$(basename ${0})${OFFBOLD}: cannot add new user: Permission denied"
    echo "Please run this script with root privileges"
    exit 1
fi

# Provide an usage statement if the user does not supply an
# account name and return with an exit status of 1.
if [[ "${#}" -lt 1 ]]
then
    echo "${BOLD}NAME${OFFBOLD}"
    echo -e "\t$(basename ${0}) - add a new user"
    echo
    echo "${BOLD}SYNOPSYS${OFFBOLD}"
    echo -e "\t${BOLD}$(basename ${0})${OFFBOLD} USER_NAME... [COMMENT]..."
    echo 
    echo "${BOLD}DESCRIPTION${OFFBOLD}"
    echo -e "\tAdds a new user to the system. USER_NAME must be provided, other parameters will be used as comments to the user creation."
    echo
    exit 1
fi

# Creates a new user based on the parameters and notify if there's an
# error during creation and return with an exit status of 1.
USER_NAME=${1}
shift 1
COMMENT=${@}
useradd -c "${COMMENT}" -m ${USERNAME}

if [[ "${?}" -ne 0 ]]
then
    echo "User ${BOLD}${USER_NAME}${OFFBOLD} couldn't be created"
    exit 1
fi

# If the user was successfully created, generates a password.
PASSWORD=$(date +%s%N | sha256sum | head -c12)
echo ${PASSWORD} | passwd --stdin ${USER_NAME}
passwd --expire ${USER_NAME}

# Display username, password and host where the account was created.
echo
echo "User successfully created:"
echo "username: $(USER_NAME)"
echo "password: $(PASSWORD)"
echo "host: $(HOSTNAME)"
exit 0
