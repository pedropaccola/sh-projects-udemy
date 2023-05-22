#!/bin/bash

# This script demonstrates I/O redirection.

# Redirects STDOUT to a file.
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}

# Redirects STDIN to a program.
read LINE < ${FILE}
echo "LINE variable contains: ${LINE}"
echo

# Redirect STOUD to a file, overwriting the file.
head -n3 /etc/passwd > ${FILE}
echo "Contents of ${FILE}:"
cat ${FILE}
echo

# Redirect STDOUT to a file, appending to the file.
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo "Contents of ${FILE}:"
cat ${FILE}
echo

echo "-----------------------------"

# File descriptors: FD 0 - STDIN; FD 1 - STDOUT; FD 2 - STDERR
# Redirect STDIN to a program, using FD 0.
read LINE 0< ${FILE}
echo "LINE variable contains: ${LINE}"
echo

# Redirect STDOUT to a file, using FD 1, overwritting that file.
head -n3 /etc/passwd 1> ${FILE}
echo "Contents of ${FILE}:"
cat ${FILE}
echo

# Do the same as above, but redirect STDERR to another file using FD 2.
ERR_FILE="/tmp/data.err"
head -n3 /etc/passwd /fakefile 1> ${FILE} 2> ${ERR_FILE}
echo "Contents of ${ERR_FILE}:"
cat ${ERR_FILE}
echo

# Redirect the STDOUT and STDERR to the same file.
head -n3 /etc/passwd /fakefile &> ${FILE}
echo "Contents of ${FILE}"
cat ${FILE}
echo

# Redirect STDOUT and STDERR through a pipe.
head -n3 /etc/passwd /fakefile |& cat -n
echo

# Send STDOUT to STDERR (The apropriate way to deal with errors message)
echo "This is STDERR!" 1>&2
echo

# Discard STDOUT
echo "Discarding STDOUT:"
head -n3 /etc/passwd /fakefile > /dev/null 
echo

# Discard STDERR 
echo "Discarding STDERR:"
head -n3 /etc/passwd /fakefile 2> /dev/null 
echo

# Discard both STDOUT and STDERR
echo "Discarding STDOUT and STDERR:"
head -n3 /etc/passwd /fakefile &> /dev/null 
echo


# Remove the files at the end of the program.
rm ${FILE} ${ERR_FILE} &> /dev/null
