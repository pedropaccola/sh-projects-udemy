#!/bin/bash

# Adds users to the same Linux system as the script is executed on

# Enforces that it is executed with root privileges.
# If not, it will exits with status of 1
if [[ "${UID}" -ne 0 ]]
then
    echo "User $(id -un) does not have root privileges"
    exit 1
fi

# Prompts to enter the username, first name and initial password
read -p 'Please enter your username: ' USER_NAME
read -p 'Please enter your name: ' COMMENT
read -p 'Please enter your password: ' PASSWORD

# Creates a new user based on the user inputs
useradd -c "${COMMENT}" -m ${USER_NAME}

# Notify if there's an error during the user creation
if [[ "${?}" -ne 0 ]]
then
    echo "User ${USER_NAME} couldn't be created"
    exit 1
fi

# If the user was successfully created, add the password and force it to expire after the first login
echo ${PASSWORD} | passwd --stdin ${USER_NAME} 

if [[ "${?}" -ne 0 ]]
then
    echo "The password couldn't be set"
    exit 1
fi

passwd --expire ${USER_NAME}

# Display username password and host where the account was created
echo
echo "User successfully created:"
echo "username: $(USER_NAME)"
echo "password: $(PASSWORD)"
echo "host: $(HOSTNAME)"
exit 0
