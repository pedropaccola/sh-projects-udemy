#!/bin/bash

# This script shows the open network ports on a system.
# User -4 as an argument to limit to tcpv4 ports.

netstat -nutl 4 | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'
