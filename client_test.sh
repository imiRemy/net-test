#!/bin/bash
#
# Script to run client side iperf3 networking tests.
#
# Usage: client_test.sh [IP address]
#   where [IP address] is an optionally supplied server IP address;
#   otherwise, the server IP address specified in the .env file is used.
#
# Copyright (C) 2023 Remy Malan  (https://github.com/imiRemy/net-test.git)
# Permission to copy and modify is granted under the MIT license
# Last revised: 2023-07-11

# Read in default values from ".env" file.

source .env
echo "Server environment variable: $SERVER_IP_DEFAULT"
echo "Logging directory: $LOG_ROOT"
echo "Test speeds: $TEST_SPEEDS"
echo "Test duration per speed: $DURATION"
echo "Test warm-up duration: $OMIT"

# Check for optionally supplied server IP address and override default if it exists.

if [ $# -eq 0 ] ; then
  IP_ADDR=$SERVER_IP_DEFAULT
else
  IP_ADDR="$1"
fi

# Set up logging.

mkdir -p "$LOG_ROOT"
TIMESTAMP=$(date --utc +%Y-%m-%d-%H%M.%S)
LOG_FILE="$LOG_ROOT/net-test-$TIMESTAMP.txt"
echo "Logging results for server at $IP_ADDR in $LOG_FILE"
echo "$0: $(date --utc)" >> $LOG_FILE
echo "Test results for server at $IP_ADDR" >> $LOG_FILE

# Write .env options into the log file.

echo "Configuration options in .env file:" >> $LOG_FILE
cat .env | awk 'NF' | grep -v '^ *#' >> $LOG_FILE
echo "" >> $LOG_FILE

# Write MTU for client and server.
# Server command can be made with key pair to avoid manual login.
# Assumes the interace name of the server is the same as the client; i.e. IF_DEFUALT from .env file.
SERVER_MTU=$(ssh $USER@$IP_ADDR ifconfig | grep $IF_DEFAULT | awk '{print $4;}')
CLIENT_MTU=$(ifconfig | grep $IF_DEFAULT | awk '{print $4;}')

echo "Server MTU: $SERVER_MTU" >> $LOG_FILE
echo "Client MTU: $CLIENT_MTU" >> $LOG_FILE
echo "" >> $LOG_FILE

echo "Testing with client/server MTU: ($CLIENT_MTU/$SERVER_MTU)"

# Run starting at the beginning of a minute.
# Test starts early for the warm-up ("omit") time to complete before the beginning of a minute.

let "START_SECOND=((60-$OMIT)%60)"
NOW=$((10#$(date --utc +%S)))
let "WAIT = (60+$START_SECOND-$NOW)%60"

echo "Test will start in $WAIT seconds..."

for RATE in $TEST_SPEEDS; do
  while [ $(date --utc +%S) -ne "$START_SECOND" ]; do sleep 1; done
  echo "Testing $RATE..."
  echo "$(date --utc +%Y-%m-%d-%H%M.%S): testing $RATE..." >> $LOG_FILE
  iperf3 --client $IP_ADDR --time $DURATION --omit $OMIT --bidir --interval 0 --bitrate $RATE --logfile $LOG_FILE
  sleep 60
done

