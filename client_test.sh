#!/bin/bash

# Usage: client_test.sh [IP address]

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
echo "Logging results for $IP_ADDR in $LOG_FILE"
echo "$0: $(date --utc)" >> $LOG_FILE
echo "$0: Test results on $IP_ADDR" >> $LOG_FILE

# Run starting at the beginning of a minute.
# Test starts early for the warm-up ("omit") time to complete before the beginning of a minute.

let "START_SECOND=((60-$OMIT)%60)"
NOW=$((10#$(date --utc +%S)))
let "WAIT = (60+$START_SECOND-$NOW)%60"

echo "Test will start in $WAIT seconds..."

for RATE in $TEST_SPEEDS; do
  while [ $(date --utc +%S) -ne "$START_SECOND" ]; do sleep 1; done
  echo "Testing $RATE..."
  iperf3 --client $IP_ADDR --time $DURATION --omit $OMIT --bidir --interval 0 --bitrate $RATE --logfile $LOG_FILE
  sleep 60
done

