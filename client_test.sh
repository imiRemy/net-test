#!/bin/bash

# Usage: client_test.sh [IP address]

# Read in default values from ".env" file.

source .env
echo "Server environment variable: $SERVER_IP_DEFAULT"
echo "Logging directory: $LOG_ROOT"
echo "Test speeds: $TEST_SPEEDS"

# Check for optionally supplied server IP address and override default if it exists.

if [ $# -eq 0 ] ; then
  IP_ADDR=$SERVER_IP_DEFAULT
else
  IP_ADDR="$1"
fi

# Set up logging.

mkdir -p "$LOG_ROOT"
LOG_FILE="$LOG_ROOT/net-test-$(date +%Y-%m-%d-%H%M.%S).txt"
echo "Logging results for $IP_ADDR in $LOG_FILE"
echo "$0: Test results on $IP_ADDR" >> $LOG_FILE

# Run tests.

for RATE in $TEST_SPEEDS; do
  echo "Testing $RATE..."
  iperf3 --client $IP_ADDR --time 30 --omit 15 --bidir --interval 0 --bitrate $RATE --logfile $LOG_FILE
done

