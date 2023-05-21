#!/bin/bash

# This script generates a list of random passwords.

# A random number as a password.
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# Three random numbers together.
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# Use the current date/time as the basis for the password.
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# Use nanoseconds to act as randomization.
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# Use date, nanoseconds, get the sha256 checksum and extract the first 16 characters
PASSWORD=$(date +%s%N | sha256sum | head -c16)
echo "${PASSWORD}"

# An even better password.
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c16)
echo "${PASSWORD}"

# Use symbols
SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
echo "${PASSWORD}${SPECIAL_CHARACTER}"
