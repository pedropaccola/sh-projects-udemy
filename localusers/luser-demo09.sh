#!/bin/bash

# This script demonstrates the case statement.

# if [[ "${1}" = 'start' ]]
# then
#     echo 'Starting.'
# elif [[ "${1}" = 'stop' ]]
# then
#     echo 'Stopping.'
# elif [[ "${1}" = 'status' ]]
# then
#     echo 'Status.'
# else
#     echo 'Supply a valid option.' 1>&2
#     exit 1
# fi


case "${1}" in
  start|--start) echo 'Starting.' ;;
  stop|--stop) echo 'Stopping.' ;;
  status|--status|state|--state) echo 'Status.' ;;
  *)
    echo 'Supply a valid option.' 1>&2
    exit 1
    ;;
esac
